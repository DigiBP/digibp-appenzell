-- FUNCTION: unemployment_service."GetUserMail"(integer)

-- DROP FUNCTION unemployment_service."GetUserMail"(integer);

CREATE OR REPLACE FUNCTION unemployment_service."GetUserMail"(
	_id_case integer)
    RETURNS json
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
AS $BODY$select row_to_json(form) FROM

(SELECT email

FROM unemployment_service.cases 
LEFT JOIN unemployment_service.users 
ON cases.id_user = users.id_user

WHERE  cases.id_case = _id_case) AS FORM;$BODY$;

ALTER FUNCTION unemployment_service."GetUserMail"(integer)
    OWNER TO hhuzlypknkbcwr;
