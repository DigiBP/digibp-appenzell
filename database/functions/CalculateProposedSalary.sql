-- FUNCTION: unemployment_service."CalculateProposedSalary"(integer)

-- DROP FUNCTION unemployment_service."CalculateProposedSalary"(integer);

CREATE OR REPLACE FUNCTION unemployment_service."CalculateProposedSalary"(
	_id integer)
    RETURNS double precision
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
AS $BODY$SELECT brutto_salary*0.8 FROM unemployment_service.cases  WHERE id_case = _id;
$BODY$;

ALTER FUNCTION unemployment_service."CalculateProposedSalary"(integer)
    OWNER TO hhuzlypknkbcwr;
