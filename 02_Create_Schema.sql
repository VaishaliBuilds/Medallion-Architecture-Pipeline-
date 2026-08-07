---- Why these schemas?

-- 1) Bronze --- Raw Data loaded from files
-- 2) Silver --- Cleaned & Transformed data
-- 3) Gold -- Business ready  reporting tables
-- 4) Audit -- Pipelines Logs, Error Logs, Load History


Create schema Silver
Create schema Bronze

Create schema Gold
Create schema Audit