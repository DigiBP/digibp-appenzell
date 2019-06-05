-- FUNCTION: unemployment_service."GetAllEmployers"()

-- DROP FUNCTION unemployment_service."GetAllEmployers"();

CREATE OR REPLACE FUNCTION unemployment_service."GetAllEmployers"(
	)
    RETURNS json
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
AS $BODY$
SELECT json_agg(employers) FROM unemployment_service.employers;
$BODY$;

ALTER FUNCTION unemployment_service."GetAllEmployers"()
    OWNER TO hhuzlypknkbcwr;
