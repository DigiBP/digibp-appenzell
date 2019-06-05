-- FUNCTION: unemployment_service."UpdateUser"(integer, character varying, character varying, date, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying)

-- DROP FUNCTION unemployment_service."UpdateUser"(integer, character varying, character varying, date, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION unemployment_service."UpdateUser"(
	_id integer,
	_firstname character varying,
	_lastname character varying,
	_birthdate date,
	_ahv_nr character varying,
	_address character varying,
	_zip_code integer,
	_city character varying,
	_citizenship character varying,
	_email character varying,
	_phone character varying,
	_gender character varying)
    RETURNS void
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
AS $BODY$UPDATE unemployment_service.users
	SET firstname=_firstname, lastname=_lastname, birthdate=_birthdate, ahv_nr=_ahv_nr, address=_address, zip_code=_zip_code, city=_city, citizenship=_citizenship, email=_email, phone=_phone, gender=_gender
	WHERE id_user =_id;
	$BODY$;

ALTER FUNCTION unemployment_service."UpdateUser"(integer, character varying, character varying, date, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying)
    OWNER TO hhuzlypknkbcwr;
