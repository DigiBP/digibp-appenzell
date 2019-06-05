-- FUNCTION: unemployment_service."InsertEmployer"(character varying)

-- DROP FUNCTION unemployment_service."InsertEmployer"(character varying);

CREATE OR REPLACE FUNCTION unemployment_service."InsertEmployer"(
	_name character varying)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$          BEGIN
            INSERT INTO unemployment_service.employers(emp_name)
            VALUES(_name);
          END;
      $BODY$;

ALTER FUNCTION unemployment_service."InsertEmployer"(character varying)
    OWNER TO hhuzlypknkbcwr;
