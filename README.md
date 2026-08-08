# Snowflake Medallion Architecture – End-to-End Data Pipeline

## 📌 Project Overview

This project demonstrates an end-to-end **Medallion Architecture data pipeline using Snowflake**.

The pipeline processes employee data from a CSV file and moves it through the following layers:

**CSV → Internal Stage → Bronze → Stream → Task → Stored Procedure → MERGE → Silver → Gold**

The project uses Snowflake features such as:

- Internal Stage
- COPY INTO
- Bronze / Silver / Gold architecture
- Streams
- Tasks
- Stored Procedures
- MERGE
- Temporary Tables
- Audit Logging
- Views
- Analytical transformations

---

## 🏗️ Architecture

```text
                    Employee CSV
                         │
                         ▼
                  Snowflake Stage
                         │
                         ▼
                     COPY INTO
                         │
                         ▼
                ┌─────────────────┐
                │  BRONZE LAYER   │
                │ Raw Employee Data│
                └─────────────────┘
                         │
                         ▼
                     STREAM
                         │
                         ▼
                      TASK
                         │
                         ▼
              Stored Procedure
                         │
                         ▼
                  Incremental Data
                         │
                         ▼
                      MERGE
                         │
                         ▼
                ┌─────────────────┐
                │  SILVER LAYER   │
                │ Clean Employee  │
                │      Data       │
                └─────────────────┘
                         │
                         ▼
                 Business Logic
                         │
                         ▼
                ┌─────────────────┐
                │   GOLD LAYER    │
                │ Reporting /     │
                │ Analytics       │
                └─────────────────┘
                         │
                         ▼
                  BI / Reporting
