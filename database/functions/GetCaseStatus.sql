-- FUNCTION: unemployment_service."GetCaseStatus"(integer)

-- DROP FUNCTION unemployment_service."GetCaseStatus"(integer);

CREATE OR REPLACE FUNCTION unemployment_service."GetCaseStatus"(
	_id integer)
    RETURNS json
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
AS $BODY$SELECT row_to_json(cases) FROM unemployment_service.cases  WHERE id_case = _id;
$BODY$;

ALTER FUNCTION unemployment_service."GetCaseStatus"(integer)
    OWNER TO hhuzlypknkbcwr;
