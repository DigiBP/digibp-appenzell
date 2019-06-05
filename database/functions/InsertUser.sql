-- FUNCTION: unemployment_service."InsertUser"(character varying, character varying, date, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying)

-- DROP FUNCTION unemployment_service."InsertUser"(character varying, character varying, date, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION unemployment_service."InsertUser"(
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
    RETURNS integer
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
AS $BODY$INSERT INTO unemployment_service.users(
	firstname, lastname, birthdate, ahv_nr, address, zip_code, city, citizenship, email, phone, gender)
	VALUES (_firstname, _lastname, _birthdate, _ahv_nr, _address, _zip_code, _city, _citizenship, _email, _phone, _gender) RETURNING id_user;$BODY$;

ALTER FUNCTION unemployment_service."InsertUser"(character varying, character varying, date, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying)
    OWNER TO hhuzlypknkbcwr;
