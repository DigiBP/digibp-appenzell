-- FUNCTION: unemployment_service."GetUserByAHV"(character varying)

-- DROP FUNCTION unemployment_service."GetUserByAHV"(character varying);

CREATE OR REPLACE FUNCTION unemployment_service."GetUserByAHV"(
	_ahv_nr character varying)
    RETURNS json
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
AS $BODY$SELECT row_to_json(users) FROM unemployment_service.users AS users WHERE users.ahv_nr = _ahv_nr;
$BODY$;

ALTER FUNCTION unemployment_service."GetUserByAHV"(character varying)
    OWNER TO hhuzlypknkbcwr;
