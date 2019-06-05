-- FUNCTION: unemployment_service."GetUserInfo"(integer)

-- DROP FUNCTION unemployment_service."GetUserInfo"(integer);

CREATE OR REPLACE FUNCTION unemployment_service."GetUserInfo"(
	_id_case integer)
    RETURNS json
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
AS $BODY$select row_to_json(form) FROM

(SELECT zip_code, 
 
 ((date_part('year', now())) 
 -
 (date_part('year', birthdate))) AS age,
 
 gender,
 
 CASE
    WHEN   date_of_work_permit >  now()  THEN 'true'
    ELSE 'false'
END AS valid_work_permit,
 citizenship,
 
 CASE
    WHEN  (date_part('year', now())) - (date_part('year', date_of_unemployment))  <= 3  THEN 'true'
    ELSE 'false'
END AS last_unemployment

FROM unemployment_service.cases 
LEFT JOIN unemployment_service.users 
ON cases.id_user = users.id_user

WHERE  cases.id_case = _id_case) AS FORM;$BODY$;

ALTER FUNCTION unemployment_service."GetUserInfo"(integer)
    OWNER TO hhuzlypknkbcwr;
