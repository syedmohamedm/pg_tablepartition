-- Procedure for dynamic table partitioning.
-- Procedure pg_dynamic_insert_trigger() need to be called along with passing two arguments, namely master_table_name and column to be checked.
-- The child table will be created automatically if doesnt exist, with the name syntax <master_table_name>_<condition_column_value>
CREATE OR REPLACE FUNCTION pg_dynamic_insert_trigger()
  RETURNS trigger AS
$BODY$
DECLARE
	c_field character varying;
	c_value character varying;
	parent_table character varying;
	child_table character varying;
BEGIN 
	-- Initiate the variables.
	c_field := TG_ARGV[1];
	EXECUTE 'select new.'|| TG_ARGV[1] ||'::text from (select $1.*) new 'USING NEW into c_value;
	parent_table := TG_ARGV[0];
	child_table := parent_table||'_'||c_value;
       
    -- Create partition table if it doesn't exist.
    IF NOT EXISTS (SELECT relname FROM pg_class WHERE relname=child_table)
		THEN 
			EXECUTE('CREATE TABLE '||child_table||' ( CHECK ( '||c_field||'='||c_value||' ) ) INHERITS ( '||parent_table||' );' );
			EXECUTE('ALTER TABLE '||child_table||' ADD CONSTRAINT '||child_table||'_pkey PRIMARY KEY ( '||c_field||', id );' );	
			EXECUTE('CREATE INDEX idx_'||child_table||'_'||c_field||' ON '||child_table||' ('||c_field||');');
    END IF;

    -- Insert new record in the corresponding partition table.
    EXECUTE 'INSERT INTO '||child_table||' SELECT $1.*' USING NEW;

    RETURN NULL;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION pg_dynamic_insert_trigger()
  OWNER TO postgres;
  

