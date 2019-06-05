-- FUNCTION: unemployment_service."UpdateCase"(integer, double precision, character, smallint, smallint)

-- DROP FUNCTION unemployment_service."UpdateCase"(integer, double precision, character, smallint, smallint);

CREATE OR REPLACE FUNCTION unemployment_service."UpdateCase"(
	_id integer,
	_brutto_salary double precision,
	_unemployment_reason character,
	_workload smallint,
	_duration_of_employment smallint)
    RETURNS void
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
AS $BODY$UPDATE unemployment_service.cases
	SET 
	id_case=_id, 
	brutto_salary=_brutto_salary, 
	unemployment_reason=_unemployment_reason,
	workload=_workload,
	duration_of_employment=_duration_of_employment
	
	WHERE id_case=_id;$BODY$;

ALTER FUNCTION unemployment_service."UpdateCase"(integer, double precision, character, smallint, smallint)
    OWNER TO hhuzlypknkbcwr;
