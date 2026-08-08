CREATE OR REPLACE PROCEDURE SP_EMPLOYEE_PIPELINE()
RETURNS VARCHAR
LANGUAGE SQL
EXECUTE AS OWNER
AS
$$
DECLARE
    V_START_TIME TIMESTAMP;
    V_ROW_COUNT NUMBER;
BEGIN

    V_START_TIME := CURRENT_TIMESTAMP();

    -- Check stream
    IF (SYSTEM$STREAM_HAS_DATA('BRONZE.STREAM_EMPLOYEE_RAW')) THEN

        -- Read stream into temp table
        CREATE OR REPLACE TEMP TABLE EMP_INCREMENTAL_PIPE AS
        SELECT
            EMPLOYEE_ID,
            EMPLOYEE_NAME,
            DEPARTMENT,
            SALARY,
            HIRE_DATE,
            METADATA$ACTION,
            METADATA$ISUPDATE
        FROM BRONZE.STREAM_EMPLOYEE_RAW;

        -- Count rows
        SELECT COUNT(*)
        INTO :V_ROW_COUNT
        FROM EMP_INCREMENTAL_PIPE;

        -- Audit Start
        INSERT INTO AUDIT.EMPLOYEE_PIPELINE_AUDIT
        (
            PIPELINE_NAME,
            START_TIME,
            STATUS,
            ROWS_PROCESSED
        )
        VALUES
        (
            'EMPLOYEE_INCREMENTAL_PIPELINE',
            :V_START_TIME,
            'RUNNING',
            :V_ROW_COUNT
        );

        -- Merge
        MERGE INTO SILVER.EMPLOYEE_SILVER A
        USING EMP_INCREMENTAL_PIPE B
        ON A.EMP_ID = B.EMPLOYEE_ID

        WHEN MATCHED
        AND B.METADATA$ACTION = 'DELETE'
        AND B.METADATA$ISUPDATE = FALSE
        THEN DELETE

        WHEN MATCHED
        AND B.METADATA$ACTION = 'INSERT'
        AND B.METADATA$ISUPDATE = TRUE
        THEN
        UPDATE SET
            EMP_NAME   = B.EMPLOYEE_NAME,
            DEPARTMENT = B.DEPARTMENT,
            SALARY     = B.SALARY,
            HIRE_DATE  = B.HIRE_DATE

        WHEN NOT MATCHED
        AND B.METADATA$ACTION = 'INSERT'
        AND B.METADATA$ISUPDATE = FALSE
        THEN
        INSERT
        (
            EMP_ID,
            EMP_NAME,
            DEPARTMENT,
            SALARY,
            HIRE_DATE
        )
        VALUES
        (
            B.EMPLOYEE_ID,
            B.EMPLOYEE_NAME,
            B.DEPARTMENT,
            B.SALARY,
            B.HIRE_DATE
        );

        -- Audit Success
        UPDATE AUDIT.EMPLOYEE_PIPELINE_AUDIT
        SET
            END_TIME = CURRENT_TIMESTAMP(),
            STATUS = 'SUCCESS'
        WHERE START_TIME = :V_START_TIME;

        RETURN 'PIPELINE EXECUTED SUCCESSFULLY';

    ELSE

        RETURN 'NO DATA FOUND IN STREAM';

    END IF;

EXCEPTION
WHEN OTHER THEN

    INSERT INTO AUDIT.EMPLOYEE_PIPELINE_AUDIT
    (
        PIPELINE_NAME,
        START_TIME,
        END_TIME,
        STATUS,
        ERROR_MESSAGE
    )
    VALUES
    (
        'EMPLOYEE_INCREMENTAL_PIPELINE',
        :V_START_TIME,
        CURRENT_TIMESTAMP(),
        'FAILED',
        'Procedure Failed'
    );

    RETURN 'PIPELINE FAILED';

END;
$$;
