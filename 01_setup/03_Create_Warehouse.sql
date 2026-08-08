--


 CREATE warehouse HR_WH
 With
 warehouse_size  = 'Xsmall'
 Auto_resume = TRUE
 Auto_suspend  = 60
 INITIALLY_suspended = true

-- Activate it

use warehouse Hr_wh

-- Check Warehouse

Show warehouses
