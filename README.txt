pg_tablepartition
=================

Automated table partitioning based on a single column.


pg_tablepart_func.sql 
=====================

Assume that we need to partition a table employee_details based on department. 

1. Copy pg_dynamic_insert_trigger() function in Postgres DB
2. Create the base table 'employee_details' with all fields and mappings. 
3. Create a trigger on employee_details, to trigger before every insert.
      CREATE TRIGGER trigger_employee_details_insert
      BEFORE INSERT
      ON employee_details
      FOR EACH ROW
      EXECUTE PROCEDURE pg_dynamic_insert_trigger('employee_details', 'department');
    Note : You need to pass the parent_table_name and column which has to be considered for partition in  pg_dynamic_insert_trigger()
4. So on every row insert into parent table get partitioned based on their department field.


<<<<<<END>>>>>>

