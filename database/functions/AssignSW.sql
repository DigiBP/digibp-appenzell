-- FUNCTION: unemployment_service."AssignSW"(integer)

-- DROP FUNCTION unemployment_service."AssignSW"(integer);

CREATE OR REPLACE FUNCTION unemployment_service."AssignSW"(
	_id_case integer)
    RETURNS json
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
AS $BODY$select row_to_json(form) FROM

(SELECT social_worker.id_social_worker, MIN(id_case) AS number_cases 

FROM unemployment_service.social_worker 
LEFT JOIN unemployment_service.cases 
ON social_worker.id_social_worker = cases.id_social_worker

GROUP BY social_worker.id_social_worker
 
) AS FORM;$BODY$;

ALTER FUNCTION unemployment_service."AssignSW"(integer)
    OWNER TO hhuzlypknkbcwr;
