-- FUNCTION: unemployment_service."InsertCase"(integer, integer, integer, date, date)

-- DROP FUNCTION unemployment_service."InsertCase"(integer, integer, integer, date, date);

CREATE OR REPLACE FUNCTION unemployment_service."InsertCase"(
	_id_user integer,
	_id_social_worker integer,
	_id_employer integer,
	_date_of_work_permit date,
	_date_of_unemployment date)
    RETURNS integer
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
AS $BODY$INSERT INTO unemployment_service.cases(
	id_user, id_employer, date_of_unemployment, date_of_work_permit)
    VALUES(_id_user, _id_employer,  _date_of_unemployment, _date_of_work_permit) RETURNING id_case;$BODY$;

ALTER FUNCTION unemployment_service."InsertCase"(integer, integer, integer, date, date)
    OWNER TO hhuzlypknkbcwr;
