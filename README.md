pg_tablepartition
=================

Automated table partitioning based on a single column.
@author Syed Mohamed M
v1.release


pg_tablepart_func.sql 
=====================

1. Copy this function in Postgres DB
2. Use pg_dynamic_insert_trigger() along with two arguments namely, table name and the column name which you considered for the base of partitioning. For example if you want to partition a table 'employee_details' based on the column 'department'. Just create the base table employee_details with all fields and mappings. After creating execute the following query in Postgres - select * from pg_dynamic_insert_trigger('employee_details','department').
3. That's it. Afterwards u need not bother about any operation related to partitioning. During each CRUD operation on employee_details respective partitioning get handled automated.

