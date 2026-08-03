# Snowflake Production Incremental ETL Pipeline

## Project Overview

This project demonstrates a real-world incremental ETL pipeline built entirely in Snowflake using Medallion Architecture.

The pipeline automatically loads CSV files into the Bronze layer, captures incremental changes using Snowflake Streams, processes data through a Stored Procedure with MERGE logic, and maintains a clean Silver layer. Audit logging and task automation are included to simulate a production environment.

---

## Architecture

CSV
│
▼
SnowSQL (PUT)
│
▼
Internal Stage
│
▼
COPY INTO
│
▼
BRONZE (Raw)
│
▼
STREAM
│
▼
Stored Procedure
│
▼
MERGE
│
▼
SILVER (Clean)
│
▼
TASK Automation
│
▼
GOLD (Reporting)

---

## Technologies

- Snowflake
- SnowSQL CLI
- SQL
- Streams
- Tasks
- Stored Procedures
- MERGE
- Internal Stage
- COPY INTO

---

## Features

- Incremental Data Loading
- Medallion Architecture
- Stream-based CDC
- Automatic MERGE
- Audit Logging
- Error Handling
- SnowSQL File Upload
- Automated Pipeline using Tasks

---

## Project Structure

01_Database

02_File_Format

03_Stage

04_Bronze

05_Stream

06_Silver

07_Procedure

08_Task

09_Audit

10_Gold

11_Testing

---

## Pipeline Flow

1. Upload CSV using SnowSQL
2. Store file in Internal Stage
3. Load into Bronze using COPY INTO
4. Stream captures changes
5. Stored Procedure processes incremental data
6. MERGE updates Silver
7. Task automates execution
8. Audit logs execution details

---

## Future Improvements

- SCD Type 2
- Notification Integration
- Email Alerts
- Dynamic Tables
- Snowpipe
- External Stage
- Power BI Dashboard

---

## Author

Vaishali Ganotra
