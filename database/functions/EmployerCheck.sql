-- FUNCTION: unemployment_service."EmployerCheck"(integer)

-- DROP FUNCTION unemployment_service."EmployerCheck"(integer);

CREATE OR REPLACE FUNCTION unemployment_service."EmployerCheck"(
	_id_case integer)
    RETURNS json
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
AS $BODY$select row_to_json(form) FROM

(SELECT emp_name, emp_email, firstname, lastname, ahv_nr

FROM unemployment_service.cases 
LEFT JOIN unemployment_service.users 
ON cases.id_user = users.id_user
LEFT JOIN unemployment_service.employers
ON employers.id_employer = cases.id_employer

WHERE  cases.id_case = _id_case) AS FORM;$BODY$;

ALTER FUNCTION unemployment_service."EmployerCheck"(integer)
    OWNER TO hhuzlypknkbcwr;
