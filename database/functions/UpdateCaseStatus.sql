-- FUNCTION: unemployment_service."UpdateCaseStatus"(integer, character)

-- DROP FUNCTION unemployment_service."UpdateCaseStatus"(integer, character);

CREATE OR REPLACE FUNCTION unemployment_service."UpdateCaseStatus"(
	_id_case integer,
	_status character)
    RETURNS void
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
AS $BODY$UPDATE unemployment_service.cases
	SET status=_status WHERE id_case=_id_case;$BODY$;

ALTER FUNCTION unemployment_service."UpdateCaseStatus"(integer, character)
    OWNER TO hhuzlypknkbcwr;
