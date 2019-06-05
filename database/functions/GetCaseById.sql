-- FUNCTION: unemployment_service."GetCaseById"(integer)

-- DROP FUNCTION unemployment_service."GetCaseById"(integer);

CREATE OR REPLACE FUNCTION unemployment_service."GetCaseById"(
	_id integer)
    RETURNS json
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
AS $BODY$SELECT row_to_json(cases) FROM unemployment_service.cases  WHERE id_case = _id;
$BODY$;

ALTER FUNCTION unemployment_service."GetCaseById"(integer)
    OWNER TO hhuzlypknkbcwr;
