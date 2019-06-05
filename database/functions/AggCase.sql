-- FUNCTION: unemployment_service."AggCase"(integer)

-- DROP FUNCTION unemployment_service."AggCase"(integer);

CREATE OR REPLACE FUNCTION unemployment_service."AggCase"(
	_id_case integer)
    RETURNS json
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
AS $BODY$SELECT row_to_json(cases) 

FROM unemployment_service.cases 
LEFT JOIN unemployment_service.users 
ON cases.id_user = users.id_user
LEFT JOIN unemployment_service.employers
ON employers.id_employer = cases.id_employer
LEFT JOIN unemployment_service.social_worker
ON social_worker.id_social_worker = cases.id_social_worker

WHERE  cases.id_case = _id_case
;$BODY$;

ALTER FUNCTION unemployment_service."AggCase"(integer)
    OWNER TO hhuzlypknkbcwr;
