--
-- PostgreSQL database dump
--

-- Dumped from database version 10.6 (Ubuntu 10.6-1.pgdg16.04+1)
-- Dumped by pg_dump version 11.2

-- Started on 2019-06-05 23:28:43

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE de1fvedlli5jkk;
--
-- TOC entry 4468 (class 1262 OID 15353247)
-- Name: de1fvedlli5jkk; Type: DATABASE; Schema: -; Owner: hhuzlypknkbcwr
--

CREATE DATABASE de1fvedlli5jkk WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


ALTER DATABASE de1fvedlli5jkk OWNER TO hhuzlypknkbcwr;

\connect de1fvedlli5jkk

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 8 (class 2615 OID 16507230)
-- Name: unemployment_service; Type: SCHEMA; Schema: -; Owner: hhuzlypknkbcwr
--

CREATE SCHEMA unemployment_service;


ALTER SCHEMA unemployment_service OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 837 (class 1247 OID 16507188)
-- Name: statusenum; Type: TYPE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TYPE public.statusenum AS ENUM (
    'open',
    'closed'
);


ALTER TYPE public.statusenum OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 853 (class 1247 OID 16507259)
-- Name: statusenum; Type: TYPE; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE TYPE unemployment_service.statusenum AS ENUM (
    'open',
    'closed'
);


ALTER TYPE unemployment_service.statusenum OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 274 (class 1255 OID 16816632)
-- Name: AggCase(integer); Type: FUNCTION; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE FUNCTION unemployment_service."AggCase"(_id_case integer) RETURNS json
    LANGUAGE sql
    AS $$SELECT row_to_json(cases) 

FROM unemployment_service.cases 
LEFT JOIN unemployment_service.users 
ON cases.id_user = users.id_user
LEFT JOIN unemployment_service.employers
ON employers.id_employer = cases.id_employer
LEFT JOIN unemployment_service.social_worker
ON social_worker.id_social_worker = cases.id_social_worker

WHERE  cases.id_case = _id_case
;$$;


ALTER FUNCTION unemployment_service."AggCase"(_id_case integer) OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 277 (class 1255 OID 16816695)
-- Name: AssignSW(integer); Type: FUNCTION; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE FUNCTION unemployment_service."AssignSW"(_id_case integer) RETURNS json
    LANGUAGE sql
    AS $$select row_to_json(form) FROM


(SELECT social_worker.id_social_worker, MIN(id_case) AS number_cases 

FROM unemployment_service.social_worker 
LEFT JOIN unemployment_service.cases 
ON social_worker.id_social_worker = cases.id_social_worker

GROUP BY social_worker.id_social_worker
 
) AS FORM;$$;


ALTER FUNCTION unemployment_service."AssignSW"(_id_case integer) OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 272 (class 1255 OID 16714127)
-- Name: CalculateProposedSalary(integer); Type: FUNCTION; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE FUNCTION unemployment_service."CalculateProposedSalary"(_id integer) RETURNS double precision
    LANGUAGE sql
    AS $$SELECT brutto_salary*0.8 FROM unemployment_service.cases  WHERE id_case = _id;
$$;


ALTER FUNCTION unemployment_service."CalculateProposedSalary"(_id integer) OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 275 (class 1255 OID 16816659)
-- Name: EmployerCheck(integer); Type: FUNCTION; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE FUNCTION unemployment_service."EmployerCheck"(_id_case integer) RETURNS json
    LANGUAGE sql
    AS $$select row_to_json(form) FROM

(SELECT emp_name, emp_email, firstname, lastname, ahv_nr

FROM unemployment_service.cases 
LEFT JOIN unemployment_service.users 
ON cases.id_user = users.id_user
LEFT JOIN unemployment_service.employers
ON employers.id_employer = cases.id_employer

WHERE  cases.id_case = _id_case) AS FORM;$$;


ALTER FUNCTION unemployment_service."EmployerCheck"(_id_case integer) OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 266 (class 1255 OID 16683307)
-- Name: GetAllEmployers(); Type: FUNCTION; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE FUNCTION unemployment_service."GetAllEmployers"() RETURNS json
    LANGUAGE sql
    AS $$
SELECT json_agg(employers) FROM unemployment_service.employers;
$$;


ALTER FUNCTION unemployment_service."GetAllEmployers"() OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 268 (class 1255 OID 16683457)
-- Name: GetCaseById(integer); Type: FUNCTION; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE FUNCTION unemployment_service."GetCaseById"(_id integer) RETURNS json
    LANGUAGE sql
    AS $$SELECT row_to_json(cases) FROM unemployment_service.cases  WHERE id_case = _id;
$$;


ALTER FUNCTION unemployment_service."GetCaseById"(_id integer) OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 282 (class 1255 OID 16883511)
-- Name: GetCaseIdByUserMail(character varying); Type: FUNCTION; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE FUNCTION unemployment_service."GetCaseIdByUserMail"(_email character varying) RETURNS json
    LANGUAGE sql
    AS $$select row_to_json(form) FROM

(SELECT id_case

FROM unemployment_service.users 
LEFT JOIN unemployment_service.cases 
ON users.id_user = cases.id_user

WHERE  users.email = _email AND cases.status = 'approved') AS FORM;$$;


ALTER FUNCTION unemployment_service."GetCaseIdByUserMail"(_email character varying) OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 269 (class 1255 OID 16714111)
-- Name: GetCaseStatus(integer); Type: FUNCTION; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE FUNCTION unemployment_service."GetCaseStatus"(_id integer) RETURNS json
    LANGUAGE sql
    AS $$SELECT row_to_json(cases) FROM unemployment_service.cases  WHERE id_case = _id;
$$;


ALTER FUNCTION unemployment_service."GetCaseStatus"(_id integer) OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 267 (class 1255 OID 16683336)
-- Name: GetUserByAHV(character varying); Type: FUNCTION; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE FUNCTION unemployment_service."GetUserByAHV"(_ahv_nr character varying) RETURNS json
    LANGUAGE sql
    AS $$SELECT row_to_json(users) FROM unemployment_service.users AS users WHERE users.ahv_nr = _ahv_nr;
$$;


ALTER FUNCTION unemployment_service."GetUserByAHV"(_ahv_nr character varying) OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 281 (class 1255 OID 16816866)
-- Name: GetUserInfo(integer); Type: FUNCTION; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE FUNCTION unemployment_service."GetUserInfo"(_id_case integer) RETURNS json
    LANGUAGE sql
    AS $$select row_to_json(form) FROM

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

WHERE  cases.id_case = _id_case) AS FORM;$$;


ALTER FUNCTION unemployment_service."GetUserInfo"(_id_case integer) OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 276 (class 1255 OID 16816668)
-- Name: GetUserMail(integer); Type: FUNCTION; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE FUNCTION unemployment_service."GetUserMail"(_id_case integer) RETURNS json
    LANGUAGE sql
    AS $$select row_to_json(form) FROM

(SELECT email

FROM unemployment_service.cases 
LEFT JOIN unemployment_service.users 
ON cases.id_user = users.id_user


WHERE  cases.id_case = _id_case) AS FORM;$$;


ALTER FUNCTION unemployment_service."GetUserMail"(_id_case integer) OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 270 (class 1255 OID 16778654)
-- Name: InsertCase(integer, integer, integer, date, date); Type: FUNCTION; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE FUNCTION unemployment_service."InsertCase"(_id_user integer, _id_social_worker integer, _id_employer integer, _date_of_work_permit date, _date_of_unemployment date) RETURNS integer
    LANGUAGE sql
    AS $$INSERT INTO unemployment_service.cases(
	id_user, id_employer, date_of_unemployment, date_of_work_permit)
    VALUES(_id_user, _id_employer,  _date_of_unemployment, _date_of_work_permit) RETURNING id_case;$$;


ALTER FUNCTION unemployment_service."InsertCase"(_id_user integer, _id_social_worker integer, _id_employer integer, _date_of_work_permit date, _date_of_unemployment date) OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 280 (class 1255 OID 16509109)
-- Name: InsertEmployer(character varying); Type: FUNCTION; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE FUNCTION unemployment_service."InsertEmployer"(_name character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$          BEGIN
            INSERT INTO unemployment_service.employers(emp_name)
            VALUES(_name);
          END;
      $$;


ALTER FUNCTION unemployment_service."InsertEmployer"(_name character varying) OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 271 (class 1255 OID 16775520)
-- Name: InsertUser(character varying, character varying, date, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE FUNCTION unemployment_service."InsertUser"(_firstname character varying, _lastname character varying, _birthdate date, _ahv_nr character varying, _address character varying, _zip_code integer, _city character varying, _citizenship character varying, _email character varying, _phone character varying, _gender character varying) RETURNS integer
    LANGUAGE sql
    AS $$INSERT INTO unemployment_service.users(
	firstname, lastname, birthdate, ahv_nr, address, zip_code, city, citizenship, email, phone, gender)
	VALUES (_firstname, _lastname, _birthdate, _ahv_nr, _address, _zip_code, _city, _citizenship, _email, _phone, _gender) RETURNING id_user;$$;


ALTER FUNCTION unemployment_service."InsertUser"(_firstname character varying, _lastname character varying, _birthdate date, _ahv_nr character varying, _address character varying, _zip_code integer, _city character varying, _citizenship character varying, _email character varying, _phone character varying, _gender character varying) OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 278 (class 1255 OID 16775500)
-- Name: UpdateCase(integer, double precision, character, smallint, smallint); Type: FUNCTION; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE FUNCTION unemployment_service."UpdateCase"(_id integer, _brutto_salary double precision, _unemployment_reason character, _workload smallint, _duration_of_employment smallint) RETURNS void
    LANGUAGE sql
    AS $$UPDATE unemployment_service.cases
	SET 
	id_case=_id, 
	brutto_salary=_brutto_salary, 
	unemployment_reason=_unemployment_reason,
	workload=_workload,
	duration_of_employment=_duration_of_employment
	
	WHERE id_case=_id;$$;


ALTER FUNCTION unemployment_service."UpdateCase"(_id integer, _brutto_salary double precision, _unemployment_reason character, _workload smallint, _duration_of_employment smallint) OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 279 (class 1255 OID 16878837)
-- Name: UpdateCaseStatus(integer, character); Type: FUNCTION; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE FUNCTION unemployment_service."UpdateCaseStatus"(_id_case integer, _status character) RETURNS void
    LANGUAGE sql
    AS $$UPDATE unemployment_service.cases
	SET status=_status WHERE id_case=_id_case;$$;


ALTER FUNCTION unemployment_service."UpdateCaseStatus"(_id_case integer, _status character) OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 273 (class 1255 OID 16775522)
-- Name: UpdateUser(integer, character varying, character varying, date, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE FUNCTION unemployment_service."UpdateUser"(_id integer, _firstname character varying, _lastname character varying, _birthdate date, _ahv_nr character varying, _address character varying, _zip_code integer, _city character varying, _citizenship character varying, _email character varying, _phone character varying, _gender character varying) RETURNS void
    LANGUAGE sql
    AS $$UPDATE unemployment_service.users
	SET firstname=_firstname, lastname=_lastname, birthdate=_birthdate, ahv_nr=_ahv_nr, address=_address, zip_code=_zip_code, city=_city, citizenship=_citizenship, email=_email, phone=_phone, gender=_gender
	WHERE id_user =_id;
	$$;


ALTER FUNCTION unemployment_service."UpdateUser"(_id integer, _firstname character varying, _lastname character varying, _birthdate date, _ahv_nr character varying, _address character varying, _zip_code integer, _city character varying, _citizenship character varying, _email character varying, _phone character varying, _gender character varying) OWNER TO hhuzlypknkbcwr;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 198 (class 1259 OID 15355040)
-- Name: act_ge_bytearray; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_ge_bytearray (
    id_ character varying(64) NOT NULL,
    rev_ integer,
    name_ character varying(255),
    deployment_id_ character varying(64),
    bytes_ bytea,
    generated_ boolean,
    tenant_id_ character varying(64),
    type_ integer,
    create_time_ timestamp without time zone,
    root_proc_inst_id_ character varying(64),
    removal_time_ timestamp without time zone
);


ALTER TABLE public.act_ge_bytearray OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 197 (class 1259 OID 15355035)
-- Name: act_ge_property; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_ge_property (
    name_ character varying(64) NOT NULL,
    value_ character varying(300),
    rev_ integer
);


ALTER TABLE public.act_ge_property OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 215 (class 1259 OID 15355383)
-- Name: act_hi_actinst; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_hi_actinst (
    id_ character varying(64) NOT NULL,
    parent_act_inst_id_ character varying(64),
    proc_def_key_ character varying(255),
    proc_def_id_ character varying(64) NOT NULL,
    root_proc_inst_id_ character varying(64),
    proc_inst_id_ character varying(64) NOT NULL,
    execution_id_ character varying(64) NOT NULL,
    act_id_ character varying(255) NOT NULL,
    task_id_ character varying(64),
    call_proc_inst_id_ character varying(64),
    call_case_inst_id_ character varying(64),
    act_name_ character varying(255),
    act_type_ character varying(255) NOT NULL,
    assignee_ character varying(64),
    start_time_ timestamp without time zone NOT NULL,
    end_time_ timestamp without time zone,
    duration_ bigint,
    act_inst_state_ integer,
    sequence_counter_ bigint,
    tenant_id_ character varying(64),
    removal_time_ timestamp without time zone
);


ALTER TABLE public.act_hi_actinst OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 221 (class 1259 OID 15355431)
-- Name: act_hi_attachment; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_hi_attachment (
    id_ character varying(64) NOT NULL,
    rev_ integer,
    user_id_ character varying(255),
    name_ character varying(255),
    description_ character varying(4000),
    type_ character varying(255),
    task_id_ character varying(64),
    root_proc_inst_id_ character varying(64),
    proc_inst_id_ character varying(64),
    url_ character varying(4000),
    content_id_ character varying(64),
    tenant_id_ character varying(64),
    create_time_ timestamp without time zone,
    removal_time_ timestamp without time zone
);


ALTER TABLE public.act_hi_attachment OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 225 (class 1259 OID 15355464)
-- Name: act_hi_batch; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_hi_batch (
    id_ character varying(64) NOT NULL,
    type_ character varying(255),
    total_jobs_ integer,
    jobs_per_seed_ integer,
    invocations_per_job_ integer,
    seed_job_def_id_ character varying(64),
    monitor_job_def_id_ character varying(64),
    batch_job_def_id_ character varying(64),
    tenant_id_ character varying(64),
    create_user_id_ character varying(255),
    start_time_ timestamp without time zone NOT NULL,
    end_time_ timestamp without time zone,
    removal_time_ timestamp without time zone
);


ALTER TABLE public.act_hi_batch OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 237 (class 1259 OID 15355735)
-- Name: act_hi_caseactinst; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_hi_caseactinst (
    id_ character varying(64) NOT NULL,
    parent_act_inst_id_ character varying(64),
    case_def_id_ character varying(64) NOT NULL,
    case_inst_id_ character varying(64) NOT NULL,
    case_act_id_ character varying(255) NOT NULL,
    task_id_ character varying(64),
    call_proc_inst_id_ character varying(64),
    call_case_inst_id_ character varying(64),
    case_act_name_ character varying(255),
    case_act_type_ character varying(255),
    create_time_ timestamp without time zone NOT NULL,
    end_time_ timestamp without time zone,
    duration_ bigint,
    state_ integer,
    required_ boolean,
    tenant_id_ character varying(64)
);


ALTER TABLE public.act_hi_caseactinst OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 236 (class 1259 OID 15355725)
-- Name: act_hi_caseinst; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_hi_caseinst (
    id_ character varying(64) NOT NULL,
    case_inst_id_ character varying(64) NOT NULL,
    business_key_ character varying(255),
    case_def_id_ character varying(64) NOT NULL,
    create_time_ timestamp without time zone NOT NULL,
    close_time_ timestamp without time zone,
    duration_ bigint,
    state_ integer,
    create_user_id_ character varying(255),
    super_case_instance_id_ character varying(64),
    super_process_instance_id_ character varying(64),
    tenant_id_ character varying(64)
);


ALTER TABLE public.act_hi_caseinst OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 220 (class 1259 OID 15355423)
-- Name: act_hi_comment; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_hi_comment (
    id_ character varying(64) NOT NULL,
    type_ character varying(255),
    time_ timestamp without time zone NOT NULL,
    user_id_ character varying(255),
    task_id_ character varying(64),
    root_proc_inst_id_ character varying(64),
    proc_inst_id_ character varying(64),
    action_ character varying(255),
    message_ character varying(4000),
    full_msg_ bytea,
    tenant_id_ character varying(64),
    removal_time_ timestamp without time zone
);


ALTER TABLE public.act_hi_comment OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 241 (class 1259 OID 15355782)
-- Name: act_hi_dec_in; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_hi_dec_in (
    id_ character varying(64) NOT NULL,
    dec_inst_id_ character varying(64) NOT NULL,
    clause_id_ character varying(64),
    clause_name_ character varying(255),
    var_type_ character varying(100),
    bytearray_id_ character varying(64),
    double_ double precision,
    long_ bigint,
    text_ character varying(4000),
    text2_ character varying(4000),
    tenant_id_ character varying(64),
    create_time_ timestamp without time zone,
    root_proc_inst_id_ character varying(64),
    removal_time_ timestamp without time zone
);


ALTER TABLE public.act_hi_dec_in OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 242 (class 1259 OID 15355790)
-- Name: act_hi_dec_out; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_hi_dec_out (
    id_ character varying(64) NOT NULL,
    dec_inst_id_ character varying(64) NOT NULL,
    clause_id_ character varying(64),
    clause_name_ character varying(255),
    rule_id_ character varying(64),
    rule_order_ integer,
    var_name_ character varying(255),
    var_type_ character varying(100),
    bytearray_id_ character varying(64),
    double_ double precision,
    long_ bigint,
    text_ character varying(4000),
    text2_ character varying(4000),
    tenant_id_ character varying(64),
    create_time_ timestamp without time zone,
    root_proc_inst_id_ character varying(64),
    removal_time_ timestamp without time zone
);


ALTER TABLE public.act_hi_dec_out OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 240 (class 1259 OID 15355774)
-- Name: act_hi_decinst; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_hi_decinst (
    id_ character varying(64) NOT NULL,
    dec_def_id_ character varying(64) NOT NULL,
    dec_def_key_ character varying(255) NOT NULL,
    dec_def_name_ character varying(255),
    proc_def_key_ character varying(255),
    proc_def_id_ character varying(64),
    proc_inst_id_ character varying(64),
    case_def_key_ character varying(255),
    case_def_id_ character varying(64),
    case_inst_id_ character varying(64),
    act_inst_id_ character varying(64),
    act_id_ character varying(255),
    eval_time_ timestamp without time zone NOT NULL,
    removal_time_ timestamp without time zone,
    collect_value_ double precision,
    user_id_ character varying(255),
    root_dec_inst_id_ character varying(64),
    root_proc_inst_id_ character varying(64),
    dec_req_id_ character varying(64),
    dec_req_key_ character varying(255),
    tenant_id_ character varying(64)
);


ALTER TABLE public.act_hi_decinst OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 218 (class 1259 OID 15355407)
-- Name: act_hi_detail; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_hi_detail (
    id_ character varying(64) NOT NULL,
    type_ character varying(255) NOT NULL,
    proc_def_key_ character varying(255),
    proc_def_id_ character varying(64),
    root_proc_inst_id_ character varying(64),
    proc_inst_id_ character varying(64),
    execution_id_ character varying(64),
    case_def_key_ character varying(255),
    case_def_id_ character varying(64),
    case_inst_id_ character varying(64),
    case_execution_id_ character varying(64),
    task_id_ character varying(64),
    act_inst_id_ character varying(64),
    var_inst_id_ character varying(64),
    name_ character varying(255) NOT NULL,
    var_type_ character varying(64),
    rev_ integer,
    time_ timestamp without time zone NOT NULL,
    bytearray_id_ character varying(64),
    double_ double precision,
    long_ bigint,
    text_ character varying(4000),
    text2_ character varying(4000),
    sequence_counter_ bigint,
    tenant_id_ character varying(64),
    operation_id_ character varying(64),
    removal_time_ timestamp without time zone
);


ALTER TABLE public.act_hi_detail OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 226 (class 1259 OID 15355472)
-- Name: act_hi_ext_task_log; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_hi_ext_task_log (
    id_ character varying(64) NOT NULL,
    timestamp_ timestamp without time zone NOT NULL,
    ext_task_id_ character varying(64) NOT NULL,
    retries_ integer,
    topic_name_ character varying(255),
    worker_id_ character varying(255),
    priority_ bigint DEFAULT 0 NOT NULL,
    error_msg_ character varying(4000),
    error_details_id_ character varying(64),
    act_id_ character varying(255),
    act_inst_id_ character varying(64),
    execution_id_ character varying(64),
    proc_inst_id_ character varying(64),
    root_proc_inst_id_ character varying(64),
    proc_def_id_ character varying(64),
    proc_def_key_ character varying(255),
    tenant_id_ character varying(64),
    state_ integer,
    removal_time_ timestamp without time zone
);


ALTER TABLE public.act_hi_ext_task_log OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 219 (class 1259 OID 15355415)
-- Name: act_hi_identitylink; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_hi_identitylink (
    id_ character varying(64) NOT NULL,
    timestamp_ timestamp without time zone NOT NULL,
    type_ character varying(255),
    user_id_ character varying(255),
    group_id_ character varying(255),
    task_id_ character varying(64),
    root_proc_inst_id_ character varying(64),
    proc_def_id_ character varying(64),
    operation_type_ character varying(64),
    assigner_id_ character varying(64),
    proc_def_key_ character varying(255),
    tenant_id_ character varying(64),
    removal_time_ timestamp without time zone
);


ALTER TABLE public.act_hi_identitylink OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 223 (class 1259 OID 15355447)
-- Name: act_hi_incident; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_hi_incident (
    id_ character varying(64) NOT NULL,
    proc_def_key_ character varying(255),
    proc_def_id_ character varying(64),
    root_proc_inst_id_ character varying(64),
    proc_inst_id_ character varying(64),
    execution_id_ character varying(64),
    create_time_ timestamp without time zone NOT NULL,
    end_time_ timestamp without time zone,
    incident_msg_ character varying(4000),
    incident_type_ character varying(255) NOT NULL,
    activity_id_ character varying(255),
    cause_incident_id_ character varying(64),
    root_cause_incident_id_ character varying(64),
    configuration_ character varying(255),
    incident_state_ integer,
    tenant_id_ character varying(64),
    job_def_id_ character varying(64),
    removal_time_ timestamp without time zone
);


ALTER TABLE public.act_hi_incident OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 224 (class 1259 OID 15355455)
-- Name: act_hi_job_log; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_hi_job_log (
    id_ character varying(64) NOT NULL,
    timestamp_ timestamp without time zone NOT NULL,
    job_id_ character varying(64) NOT NULL,
    job_duedate_ timestamp without time zone,
    job_retries_ integer,
    job_priority_ bigint DEFAULT 0 NOT NULL,
    job_exception_msg_ character varying(4000),
    job_exception_stack_id_ character varying(64),
    job_state_ integer,
    job_def_id_ character varying(64),
    job_def_type_ character varying(255),
    job_def_configuration_ character varying(255),
    act_id_ character varying(255),
    execution_id_ character varying(64),
    root_proc_inst_id_ character varying(64),
    process_instance_id_ character varying(64),
    process_def_id_ character varying(64),
    process_def_key_ character varying(255),
    deployment_id_ character varying(64),
    sequence_counter_ bigint,
    tenant_id_ character varying(64),
    removal_time_ timestamp without time zone
);


ALTER TABLE public.act_hi_job_log OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 222 (class 1259 OID 15355439)
-- Name: act_hi_op_log; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_hi_op_log (
    id_ character varying(64) NOT NULL,
    deployment_id_ character varying(64),
    proc_def_id_ character varying(64),
    proc_def_key_ character varying(255),
    root_proc_inst_id_ character varying(64),
    proc_inst_id_ character varying(64),
    execution_id_ character varying(64),
    case_def_id_ character varying(64),
    case_inst_id_ character varying(64),
    case_execution_id_ character varying(64),
    task_id_ character varying(64),
    job_id_ character varying(64),
    job_def_id_ character varying(64),
    batch_id_ character varying(64),
    user_id_ character varying(255),
    timestamp_ timestamp without time zone NOT NULL,
    operation_type_ character varying(64),
    operation_id_ character varying(64),
    entity_type_ character varying(30),
    property_ character varying(64),
    org_value_ character varying(4000),
    new_value_ character varying(4000),
    tenant_id_ character varying(64),
    removal_time_ timestamp without time zone
);


ALTER TABLE public.act_hi_op_log OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 214 (class 1259 OID 15355373)
-- Name: act_hi_procinst; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_hi_procinst (
    id_ character varying(64) NOT NULL,
    proc_inst_id_ character varying(64) NOT NULL,
    business_key_ character varying(255),
    proc_def_key_ character varying(255),
    proc_def_id_ character varying(64) NOT NULL,
    start_time_ timestamp without time zone NOT NULL,
    end_time_ timestamp without time zone,
    removal_time_ timestamp without time zone,
    duration_ bigint,
    start_user_id_ character varying(255),
    start_act_id_ character varying(255),
    end_act_id_ character varying(255),
    super_process_instance_id_ character varying(64),
    root_proc_inst_id_ character varying(64),
    super_case_instance_id_ character varying(64),
    case_inst_id_ character varying(64),
    delete_reason_ character varying(4000),
    tenant_id_ character varying(64),
    state_ character varying(255)
);


ALTER TABLE public.act_hi_procinst OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 216 (class 1259 OID 15355391)
-- Name: act_hi_taskinst; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_hi_taskinst (
    id_ character varying(64) NOT NULL,
    task_def_key_ character varying(255),
    proc_def_key_ character varying(255),
    proc_def_id_ character varying(64),
    root_proc_inst_id_ character varying(64),
    proc_inst_id_ character varying(64),
    execution_id_ character varying(64),
    case_def_key_ character varying(255),
    case_def_id_ character varying(64),
    case_inst_id_ character varying(64),
    case_execution_id_ character varying(64),
    act_inst_id_ character varying(64),
    name_ character varying(255),
    parent_task_id_ character varying(64),
    description_ character varying(4000),
    owner_ character varying(255),
    assignee_ character varying(255),
    start_time_ timestamp without time zone NOT NULL,
    end_time_ timestamp without time zone,
    duration_ bigint,
    delete_reason_ character varying(4000),
    priority_ integer,
    due_date_ timestamp without time zone,
    follow_up_date_ timestamp without time zone,
    tenant_id_ character varying(64),
    removal_time_ timestamp without time zone
);


ALTER TABLE public.act_hi_taskinst OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 217 (class 1259 OID 15355399)
-- Name: act_hi_varinst; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_hi_varinst (
    id_ character varying(64) NOT NULL,
    proc_def_key_ character varying(255),
    proc_def_id_ character varying(64),
    root_proc_inst_id_ character varying(64),
    proc_inst_id_ character varying(64),
    execution_id_ character varying(64),
    act_inst_id_ character varying(64),
    case_def_key_ character varying(255),
    case_def_id_ character varying(64),
    case_inst_id_ character varying(64),
    case_execution_id_ character varying(64),
    task_id_ character varying(64),
    name_ character varying(255) NOT NULL,
    var_type_ character varying(100),
    create_time_ timestamp without time zone,
    rev_ integer,
    bytearray_id_ character varying(64),
    double_ double precision,
    long_ bigint,
    text_ character varying(4000),
    text2_ character varying(4000),
    tenant_id_ character varying(64),
    state_ character varying(20),
    removal_time_ timestamp without time zone
);


ALTER TABLE public.act_hi_varinst OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 227 (class 1259 OID 15355571)
-- Name: act_id_group; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_id_group (
    id_ character varying(64) NOT NULL,
    rev_ integer,
    name_ character varying(255),
    type_ character varying(255)
);


ALTER TABLE public.act_id_group OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 230 (class 1259 OID 15355592)
-- Name: act_id_info; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_id_info (
    id_ character varying(64) NOT NULL,
    rev_ integer,
    user_id_ character varying(64),
    type_ character varying(64),
    key_ character varying(255),
    value_ character varying(255),
    password_ bytea,
    parent_id_ character varying(255)
);


ALTER TABLE public.act_id_info OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 228 (class 1259 OID 15355579)
-- Name: act_id_membership; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_id_membership (
    user_id_ character varying(64) NOT NULL,
    group_id_ character varying(64) NOT NULL
);


ALTER TABLE public.act_id_membership OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 231 (class 1259 OID 15355600)
-- Name: act_id_tenant; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_id_tenant (
    id_ character varying(64) NOT NULL,
    rev_ integer,
    name_ character varying(255)
);


ALTER TABLE public.act_id_tenant OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 232 (class 1259 OID 15355605)
-- Name: act_id_tenant_member; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_id_tenant_member (
    id_ character varying(64) NOT NULL,
    tenant_id_ character varying(64) NOT NULL,
    user_id_ character varying(64),
    group_id_ character varying(64)
);


ALTER TABLE public.act_id_tenant_member OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 229 (class 1259 OID 15355584)
-- Name: act_id_user; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_id_user (
    id_ character varying(64) NOT NULL,
    rev_ integer,
    first_ character varying(255),
    last_ character varying(255),
    email_ character varying(255),
    pwd_ character varying(255),
    salt_ character varying(255),
    lock_exp_time_ timestamp without time zone,
    attempts_ integer,
    picture_id_ character varying(64)
);


ALTER TABLE public.act_id_user OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 233 (class 1259 OID 15355644)
-- Name: act_re_case_def; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_re_case_def (
    id_ character varying(64) NOT NULL,
    rev_ integer,
    category_ character varying(255),
    name_ character varying(255),
    key_ character varying(255) NOT NULL,
    version_ integer NOT NULL,
    deployment_id_ character varying(64),
    resource_name_ character varying(4000),
    dgrm_resource_name_ character varying(4000),
    tenant_id_ character varying(64),
    history_ttl_ integer
);


ALTER TABLE public.act_re_case_def OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 238 (class 1259 OID 15355750)
-- Name: act_re_decision_def; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_re_decision_def (
    id_ character varying(64) NOT NULL,
    rev_ integer,
    category_ character varying(255),
    name_ character varying(255),
    key_ character varying(255) NOT NULL,
    version_ integer NOT NULL,
    deployment_id_ character varying(64),
    resource_name_ character varying(4000),
    dgrm_resource_name_ character varying(4000),
    dec_req_id_ character varying(64),
    dec_req_key_ character varying(255),
    tenant_id_ character varying(64),
    history_ttl_ integer,
    version_tag_ character varying(64)
);


ALTER TABLE public.act_re_decision_def OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 239 (class 1259 OID 15355758)
-- Name: act_re_decision_req_def; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_re_decision_req_def (
    id_ character varying(64) NOT NULL,
    rev_ integer,
    category_ character varying(255),
    name_ character varying(255),
    key_ character varying(255) NOT NULL,
    version_ integer NOT NULL,
    deployment_id_ character varying(64),
    resource_name_ character varying(4000),
    dgrm_resource_name_ character varying(4000),
    tenant_id_ character varying(64)
);


ALTER TABLE public.act_re_decision_req_def OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 199 (class 1259 OID 15355048)
-- Name: act_re_deployment; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_re_deployment (
    id_ character varying(64) NOT NULL,
    name_ character varying(255),
    deploy_time_ timestamp without time zone,
    source_ character varying(255),
    tenant_id_ character varying(64)
);


ALTER TABLE public.act_re_deployment OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 203 (class 1259 OID 15355082)
-- Name: act_re_procdef; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_re_procdef (
    id_ character varying(64) NOT NULL,
    rev_ integer,
    category_ character varying(255),
    name_ character varying(255),
    key_ character varying(255) NOT NULL,
    version_ integer NOT NULL,
    deployment_id_ character varying(64),
    resource_name_ character varying(4000),
    dgrm_resource_name_ character varying(4000),
    has_start_form_key_ boolean,
    suspension_state_ integer,
    tenant_id_ character varying(64),
    version_tag_ character varying(64),
    history_ttl_ integer,
    startable_ boolean DEFAULT true NOT NULL
);


ALTER TABLE public.act_re_procdef OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 209 (class 1259 OID 15355131)
-- Name: act_ru_authorization; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_ru_authorization (
    id_ character varying(64) NOT NULL,
    rev_ integer NOT NULL,
    type_ integer NOT NULL,
    group_id_ character varying(255),
    user_id_ character varying(255),
    resource_type_ integer NOT NULL,
    resource_id_ character varying(255),
    perms_ integer
);


ALTER TABLE public.act_ru_authorization OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 213 (class 1259 OID 15355162)
-- Name: act_ru_batch; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_ru_batch (
    id_ character varying(64) NOT NULL,
    rev_ integer NOT NULL,
    type_ character varying(255),
    total_jobs_ integer,
    jobs_created_ integer,
    jobs_per_seed_ integer,
    invocations_per_job_ integer,
    seed_job_def_id_ character varying(64),
    batch_job_def_id_ character varying(64),
    monitor_job_def_id_ character varying(64),
    suspension_state_ integer,
    configuration_ character varying(255),
    tenant_id_ character varying(64),
    create_user_id_ character varying(255)
);


ALTER TABLE public.act_ru_batch OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 234 (class 1259 OID 15355652)
-- Name: act_ru_case_execution; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_ru_case_execution (
    id_ character varying(64) NOT NULL,
    rev_ integer,
    case_inst_id_ character varying(64),
    super_case_exec_ character varying(64),
    super_exec_ character varying(64),
    business_key_ character varying(255),
    parent_id_ character varying(64),
    case_def_id_ character varying(64),
    act_id_ character varying(255),
    prev_state_ integer,
    current_state_ integer,
    required_ boolean,
    tenant_id_ character varying(64)
);


ALTER TABLE public.act_ru_case_execution OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 235 (class 1259 OID 15355660)
-- Name: act_ru_case_sentry_part; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_ru_case_sentry_part (
    id_ character varying(64) NOT NULL,
    rev_ integer,
    case_inst_id_ character varying(64),
    case_exec_id_ character varying(64),
    sentry_id_ character varying(255),
    type_ character varying(255),
    source_case_exec_id_ character varying(64),
    standard_event_ character varying(255),
    source_ character varying(255),
    variable_event_ character varying(255),
    variable_name_ character varying(255),
    satisfied_ boolean,
    tenant_id_ character varying(64)
);


ALTER TABLE public.act_ru_case_sentry_part OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 207 (class 1259 OID 15355115)
-- Name: act_ru_event_subscr; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_ru_event_subscr (
    id_ character varying(64) NOT NULL,
    rev_ integer,
    event_type_ character varying(255) NOT NULL,
    event_name_ character varying(255),
    execution_id_ character varying(64),
    proc_inst_id_ character varying(64),
    activity_id_ character varying(255),
    configuration_ character varying(255),
    created_ timestamp without time zone NOT NULL,
    tenant_id_ character varying(64)
);


ALTER TABLE public.act_ru_event_subscr OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 200 (class 1259 OID 15355056)
-- Name: act_ru_execution; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_ru_execution (
    id_ character varying(64) NOT NULL,
    rev_ integer,
    root_proc_inst_id_ character varying(64),
    proc_inst_id_ character varying(64),
    business_key_ character varying(255),
    parent_id_ character varying(64),
    proc_def_id_ character varying(64),
    super_exec_ character varying(64),
    super_case_exec_ character varying(64),
    case_inst_id_ character varying(64),
    act_id_ character varying(255),
    act_inst_id_ character varying(64),
    is_active_ boolean,
    is_concurrent_ boolean,
    is_scope_ boolean,
    is_event_scope_ boolean,
    suspension_state_ integer,
    cached_ent_state_ integer,
    sequence_counter_ bigint,
    tenant_id_ character varying(64)
);


ALTER TABLE public.act_ru_execution OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 212 (class 1259 OID 15355153)
-- Name: act_ru_ext_task; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_ru_ext_task (
    id_ character varying(64) NOT NULL,
    rev_ integer NOT NULL,
    worker_id_ character varying(255),
    topic_name_ character varying(255),
    retries_ integer,
    error_msg_ character varying(4000),
    error_details_id_ character varying(64),
    lock_exp_time_ timestamp without time zone,
    suspension_state_ integer,
    execution_id_ character varying(64),
    proc_inst_id_ character varying(64),
    proc_def_id_ character varying(64),
    proc_def_key_ character varying(255),
    act_id_ character varying(255),
    act_inst_id_ character varying(64),
    tenant_id_ character varying(64),
    priority_ bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.act_ru_ext_task OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 210 (class 1259 OID 15355139)
-- Name: act_ru_filter; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_ru_filter (
    id_ character varying(64) NOT NULL,
    rev_ integer NOT NULL,
    resource_type_ character varying(255) NOT NULL,
    name_ character varying(255) NOT NULL,
    owner_ character varying(255),
    query_ text NOT NULL,
    properties_ text
);


ALTER TABLE public.act_ru_filter OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 205 (class 1259 OID 15355099)
-- Name: act_ru_identitylink; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_ru_identitylink (
    id_ character varying(64) NOT NULL,
    rev_ integer,
    group_id_ character varying(255),
    type_ character varying(255),
    user_id_ character varying(255),
    task_id_ character varying(64),
    proc_def_id_ character varying(64),
    tenant_id_ character varying(64)
);


ALTER TABLE public.act_ru_identitylink OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 208 (class 1259 OID 15355123)
-- Name: act_ru_incident; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_ru_incident (
    id_ character varying(64) NOT NULL,
    rev_ integer NOT NULL,
    incident_timestamp_ timestamp without time zone NOT NULL,
    incident_msg_ character varying(4000),
    incident_type_ character varying(255) NOT NULL,
    execution_id_ character varying(64),
    activity_id_ character varying(255),
    proc_inst_id_ character varying(64),
    proc_def_id_ character varying(64),
    cause_incident_id_ character varying(64),
    root_cause_incident_id_ character varying(64),
    configuration_ character varying(255),
    tenant_id_ character varying(64),
    job_def_id_ character varying(64)
);


ALTER TABLE public.act_ru_incident OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 201 (class 1259 OID 15355064)
-- Name: act_ru_job; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_ru_job (
    id_ character varying(64) NOT NULL,
    rev_ integer,
    type_ character varying(255) NOT NULL,
    lock_exp_time_ timestamp without time zone,
    lock_owner_ character varying(255),
    exclusive_ boolean,
    execution_id_ character varying(64),
    process_instance_id_ character varying(64),
    process_def_id_ character varying(64),
    process_def_key_ character varying(255),
    retries_ integer,
    exception_stack_id_ character varying(64),
    exception_msg_ character varying(4000),
    duedate_ timestamp without time zone,
    repeat_ character varying(255),
    handler_type_ character varying(255),
    handler_cfg_ character varying(4000),
    deployment_id_ character varying(64),
    suspension_state_ integer DEFAULT 1 NOT NULL,
    job_def_id_ character varying(64),
    priority_ bigint DEFAULT 0 NOT NULL,
    sequence_counter_ bigint,
    tenant_id_ character varying(64),
    create_time_ timestamp without time zone
);


ALTER TABLE public.act_ru_job OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 202 (class 1259 OID 15355074)
-- Name: act_ru_jobdef; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_ru_jobdef (
    id_ character varying(64) NOT NULL,
    rev_ integer,
    proc_def_id_ character varying(64),
    proc_def_key_ character varying(255),
    act_id_ character varying(255),
    job_type_ character varying(255) NOT NULL,
    job_configuration_ character varying(255),
    suspension_state_ integer,
    job_priority_ bigint,
    tenant_id_ character varying(64)
);


ALTER TABLE public.act_ru_jobdef OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 211 (class 1259 OID 15355147)
-- Name: act_ru_meter_log; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_ru_meter_log (
    id_ character varying(64) NOT NULL,
    name_ character varying(64) NOT NULL,
    reporter_ character varying(255),
    value_ bigint,
    timestamp_ timestamp without time zone,
    milliseconds_ bigint DEFAULT 0
);


ALTER TABLE public.act_ru_meter_log OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 204 (class 1259 OID 15355091)
-- Name: act_ru_task; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_ru_task (
    id_ character varying(64) NOT NULL,
    rev_ integer,
    execution_id_ character varying(64),
    proc_inst_id_ character varying(64),
    proc_def_id_ character varying(64),
    case_execution_id_ character varying(64),
    case_inst_id_ character varying(64),
    case_def_id_ character varying(64),
    name_ character varying(255),
    parent_task_id_ character varying(64),
    description_ character varying(4000),
    task_def_key_ character varying(255),
    owner_ character varying(255),
    assignee_ character varying(255),
    delegation_ character varying(64),
    priority_ integer,
    create_time_ timestamp without time zone,
    due_date_ timestamp without time zone,
    follow_up_date_ timestamp without time zone,
    suspension_state_ integer,
    tenant_id_ character varying(64)
);


ALTER TABLE public.act_ru_task OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 206 (class 1259 OID 15355107)
-- Name: act_ru_variable; Type: TABLE; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE TABLE public.act_ru_variable (
    id_ character varying(64) NOT NULL,
    rev_ integer,
    type_ character varying(255) NOT NULL,
    name_ character varying(255) NOT NULL,
    execution_id_ character varying(64),
    proc_inst_id_ character varying(64),
    case_execution_id_ character varying(64),
    case_inst_id_ character varying(64),
    task_id_ character varying(64),
    bytearray_id_ character varying(64),
    double_ double precision,
    long_ bigint,
    text_ character varying(4000),
    text2_ character varying(4000),
    var_scope_ character varying(64),
    sequence_counter_ bigint,
    is_concurrent_local_ boolean,
    tenant_id_ character varying(64)
);


ALTER TABLE public.act_ru_variable OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 253 (class 1259 OID 16507271)
-- Name: cases; Type: TABLE; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE TABLE unemployment_service.cases (
    id_case integer NOT NULL,
    id_social_worker integer NOT NULL,
    id_user integer NOT NULL,
    id_employer integer NOT NULL,
    date_of_unemployment date NOT NULL,
    date_of_work_permit date,
    unemployment_reason character varying(45),
    status character varying(45) DEFAULT 'open'::character varying,
    brutto_salary double precision,
    duration_of_employment smallint,
    workload smallint
);


ALTER TABLE unemployment_service.cases OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 252 (class 1259 OID 16507269)
-- Name: cases_employers_idemployers1_seq; Type: SEQUENCE; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE SEQUENCE unemployment_service.cases_employers_idemployers1_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE unemployment_service.cases_employers_idemployers1_seq OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 4472 (class 0 OID 0)
-- Dependencies: 252
-- Name: cases_employers_idemployers1_seq; Type: SEQUENCE OWNED BY; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

ALTER SEQUENCE unemployment_service.cases_employers_idemployers1_seq OWNED BY unemployment_service.cases.id_employer;


--
-- TOC entry 249 (class 1259 OID 16507263)
-- Name: cases_idcase_seq; Type: SEQUENCE; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE SEQUENCE unemployment_service.cases_idcase_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE unemployment_service.cases_idcase_seq OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 4473 (class 0 OID 0)
-- Dependencies: 249
-- Name: cases_idcase_seq; Type: SEQUENCE OWNED BY; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

ALTER SEQUENCE unemployment_service.cases_idcase_seq OWNED BY unemployment_service.cases.id_case;


--
-- TOC entry 250 (class 1259 OID 16507265)
-- Name: cases_social_worker_idsocial_worker_seq; Type: SEQUENCE; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE SEQUENCE unemployment_service.cases_social_worker_idsocial_worker_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE unemployment_service.cases_social_worker_idsocial_worker_seq OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 4474 (class 0 OID 0)
-- Dependencies: 250
-- Name: cases_social_worker_idsocial_worker_seq; Type: SEQUENCE OWNED BY; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

ALTER SEQUENCE unemployment_service.cases_social_worker_idsocial_worker_seq OWNED BY unemployment_service.cases.id_social_worker;


--
-- TOC entry 251 (class 1259 OID 16507267)
-- Name: cases_users_iduser_seq; Type: SEQUENCE; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE SEQUENCE unemployment_service.cases_users_iduser_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE unemployment_service.cases_users_iduser_seq OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 4475 (class 0 OID 0)
-- Dependencies: 251
-- Name: cases_users_iduser_seq; Type: SEQUENCE OWNED BY; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

ALTER SEQUENCE unemployment_service.cases_users_iduser_seq OWNED BY unemployment_service.cases.id_user;


--
-- TOC entry 248 (class 1259 OID 16507252)
-- Name: employers; Type: TABLE; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE TABLE unemployment_service.employers (
    id_employer integer NOT NULL,
    emp_name character varying(45) NOT NULL,
    emp_email character varying
);


ALTER TABLE unemployment_service.employers OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 247 (class 1259 OID 16507250)
-- Name: employers_idemployers_seq; Type: SEQUENCE; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE SEQUENCE unemployment_service.employers_idemployers_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE unemployment_service.employers_idemployers_seq OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 4476 (class 0 OID 0)
-- Dependencies: 247
-- Name: employers_idemployers_seq; Type: SEQUENCE OWNED BY; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

ALTER SEQUENCE unemployment_service.employers_idemployers_seq OWNED BY unemployment_service.employers.id_employer;


--
-- TOC entry 244 (class 1259 OID 16507233)
-- Name: social_worker; Type: TABLE; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE TABLE unemployment_service.social_worker (
    id_social_worker integer NOT NULL,
    lastname character varying,
    firstname character varying,
    email character(45)
);


ALTER TABLE unemployment_service.social_worker OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 243 (class 1259 OID 16507231)
-- Name: social_worker_idsocial_worker_seq; Type: SEQUENCE; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE SEQUENCE unemployment_service.social_worker_idsocial_worker_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE unemployment_service.social_worker_idsocial_worker_seq OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 4477 (class 0 OID 0)
-- Dependencies: 243
-- Name: social_worker_idsocial_worker_seq; Type: SEQUENCE OWNED BY; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

ALTER SEQUENCE unemployment_service.social_worker_idsocial_worker_seq OWNED BY unemployment_service.social_worker.id_social_worker;


--
-- TOC entry 246 (class 1259 OID 16507241)
-- Name: users; Type: TABLE; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE TABLE unemployment_service.users (
    id_user integer NOT NULL,
    firstname character varying(45) NOT NULL,
    lastname character varying(45) NOT NULL,
    birthdate date NOT NULL,
    ahv_nr character varying(45) NOT NULL,
    address text NOT NULL,
    zip_code integer NOT NULL,
    city character varying(45) NOT NULL,
    citizenship character varying(45) NOT NULL,
    email character varying(45) NOT NULL,
    phone character varying(45),
    gender character varying(6)
);


ALTER TABLE unemployment_service.users OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 245 (class 1259 OID 16507239)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE SEQUENCE unemployment_service.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE unemployment_service.users_user_id_seq OWNER TO hhuzlypknkbcwr;

--
-- TOC entry 4478 (class 0 OID 0)
-- Dependencies: 245
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

ALTER SEQUENCE unemployment_service.users_user_id_seq OWNED BY unemployment_service.users.id_user;


--
-- TOC entry 3972 (class 2604 OID 16507274)
-- Name: cases id_case; Type: DEFAULT; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY unemployment_service.cases ALTER COLUMN id_case SET DEFAULT nextval('unemployment_service.cases_idcase_seq'::regclass);


--
-- TOC entry 3973 (class 2604 OID 16507275)
-- Name: cases id_social_worker; Type: DEFAULT; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY unemployment_service.cases ALTER COLUMN id_social_worker SET DEFAULT nextval('unemployment_service.cases_social_worker_idsocial_worker_seq'::regclass);


--
-- TOC entry 3974 (class 2604 OID 16507276)
-- Name: cases id_user; Type: DEFAULT; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY unemployment_service.cases ALTER COLUMN id_user SET DEFAULT nextval('unemployment_service.cases_users_iduser_seq'::regclass);


--
-- TOC entry 3975 (class 2604 OID 16507277)
-- Name: cases id_employer; Type: DEFAULT; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY unemployment_service.cases ALTER COLUMN id_employer SET DEFAULT nextval('unemployment_service.cases_employers_idemployers1_seq'::regclass);


--
-- TOC entry 3971 (class 2604 OID 16507255)
-- Name: employers id_employer; Type: DEFAULT; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY unemployment_service.employers ALTER COLUMN id_employer SET DEFAULT nextval('unemployment_service.employers_idemployers_seq'::regclass);


--
-- TOC entry 3969 (class 2604 OID 16507236)
-- Name: social_worker id_social_worker; Type: DEFAULT; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY unemployment_service.social_worker ALTER COLUMN id_social_worker SET DEFAULT nextval('unemployment_service.social_worker_idsocial_worker_seq'::regclass);


--
-- TOC entry 3970 (class 2604 OID 16507244)
-- Name: users id_user; Type: DEFAULT; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY unemployment_service.users ALTER COLUMN id_user SET DEFAULT nextval('unemployment_service.users_user_id_seq'::regclass);


--
-- TOC entry 3980 (class 2606 OID 15355047)
-- Name: act_ge_bytearray act_ge_bytearray_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ge_bytearray
    ADD CONSTRAINT act_ge_bytearray_pkey PRIMARY KEY (id_);


--
-- TOC entry 3978 (class 2606 OID 15355039)
-- Name: act_ge_property act_ge_property_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ge_property
    ADD CONSTRAINT act_ge_property_pkey PRIMARY KEY (name_);


--
-- TOC entry 4101 (class 2606 OID 15355390)
-- Name: act_hi_actinst act_hi_actinst_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_hi_actinst
    ADD CONSTRAINT act_hi_actinst_pkey PRIMARY KEY (id_);


--
-- TOC entry 4163 (class 2606 OID 15355438)
-- Name: act_hi_attachment act_hi_attachment_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_hi_attachment
    ADD CONSTRAINT act_hi_attachment_pkey PRIMARY KEY (id_);


--
-- TOC entry 4196 (class 2606 OID 15355471)
-- Name: act_hi_batch act_hi_batch_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_hi_batch
    ADD CONSTRAINT act_hi_batch_pkey PRIMARY KEY (id_);


--
-- TOC entry 4249 (class 2606 OID 15355742)
-- Name: act_hi_caseactinst act_hi_caseactinst_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_hi_caseactinst
    ADD CONSTRAINT act_hi_caseactinst_pkey PRIMARY KEY (id_);


--
-- TOC entry 4242 (class 2606 OID 15355734)
-- Name: act_hi_caseinst act_hi_caseinst_case_inst_id__key; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_hi_caseinst
    ADD CONSTRAINT act_hi_caseinst_case_inst_id__key UNIQUE (case_inst_id_);


--
-- TOC entry 4244 (class 2606 OID 15355732)
-- Name: act_hi_caseinst act_hi_caseinst_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_hi_caseinst
    ADD CONSTRAINT act_hi_caseinst_pkey PRIMARY KEY (id_);


--
-- TOC entry 4157 (class 2606 OID 15355430)
-- Name: act_hi_comment act_hi_comment_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_hi_comment
    ADD CONSTRAINT act_hi_comment_pkey PRIMARY KEY (id_);


--
-- TOC entry 4277 (class 2606 OID 15355789)
-- Name: act_hi_dec_in act_hi_dec_in_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_hi_dec_in
    ADD CONSTRAINT act_hi_dec_in_pkey PRIMARY KEY (id_);


--
-- TOC entry 4283 (class 2606 OID 15355797)
-- Name: act_hi_dec_out act_hi_dec_out_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_hi_dec_out
    ADD CONSTRAINT act_hi_dec_out_pkey PRIMARY KEY (id_);


--
-- TOC entry 4262 (class 2606 OID 15355781)
-- Name: act_hi_decinst act_hi_decinst_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_hi_decinst
    ADD CONSTRAINT act_hi_decinst_pkey PRIMARY KEY (id_);


--
-- TOC entry 4133 (class 2606 OID 15355414)
-- Name: act_hi_detail act_hi_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_hi_detail
    ADD CONSTRAINT act_hi_detail_pkey PRIMARY KEY (id_);


--
-- TOC entry 4198 (class 2606 OID 15355480)
-- Name: act_hi_ext_task_log act_hi_ext_task_log_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_hi_ext_task_log
    ADD CONSTRAINT act_hi_ext_task_log_pkey PRIMARY KEY (id_);


--
-- TOC entry 4148 (class 2606 OID 15355422)
-- Name: act_hi_identitylink act_hi_identitylink_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_hi_identitylink
    ADD CONSTRAINT act_hi_identitylink_pkey PRIMARY KEY (id_);


--
-- TOC entry 4178 (class 2606 OID 15355454)
-- Name: act_hi_incident act_hi_incident_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_hi_incident
    ADD CONSTRAINT act_hi_incident_pkey PRIMARY KEY (id_);


--
-- TOC entry 4185 (class 2606 OID 15355463)
-- Name: act_hi_job_log act_hi_job_log_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_hi_job_log
    ADD CONSTRAINT act_hi_job_log_pkey PRIMARY KEY (id_);


--
-- TOC entry 4170 (class 2606 OID 15355446)
-- Name: act_hi_op_log act_hi_op_log_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_hi_op_log
    ADD CONSTRAINT act_hi_op_log_pkey PRIMARY KEY (id_);


--
-- TOC entry 4089 (class 2606 OID 15355380)
-- Name: act_hi_procinst act_hi_procinst_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_hi_procinst
    ADD CONSTRAINT act_hi_procinst_pkey PRIMARY KEY (id_);


--
-- TOC entry 4091 (class 2606 OID 15355382)
-- Name: act_hi_procinst act_hi_procinst_proc_inst_id__key; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_hi_procinst
    ADD CONSTRAINT act_hi_procinst_proc_inst_id__key UNIQUE (proc_inst_id_);


--
-- TOC entry 4113 (class 2606 OID 15355398)
-- Name: act_hi_taskinst act_hi_taskinst_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_hi_taskinst
    ADD CONSTRAINT act_hi_taskinst_pkey PRIMARY KEY (id_);


--
-- TOC entry 4123 (class 2606 OID 15355406)
-- Name: act_hi_varinst act_hi_varinst_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_hi_varinst
    ADD CONSTRAINT act_hi_varinst_pkey PRIMARY KEY (id_);


--
-- TOC entry 4207 (class 2606 OID 15355578)
-- Name: act_id_group act_id_group_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_id_group
    ADD CONSTRAINT act_id_group_pkey PRIMARY KEY (id_);


--
-- TOC entry 4215 (class 2606 OID 15355599)
-- Name: act_id_info act_id_info_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_id_info
    ADD CONSTRAINT act_id_info_pkey PRIMARY KEY (id_);


--
-- TOC entry 4209 (class 2606 OID 15355583)
-- Name: act_id_membership act_id_membership_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_id_membership
    ADD CONSTRAINT act_id_membership_pkey PRIMARY KEY (user_id_, group_id_);


--
-- TOC entry 4219 (class 2606 OID 15355609)
-- Name: act_id_tenant_member act_id_tenant_member_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_id_tenant_member
    ADD CONSTRAINT act_id_tenant_member_pkey PRIMARY KEY (id_);


--
-- TOC entry 4217 (class 2606 OID 15355604)
-- Name: act_id_tenant act_id_tenant_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_id_tenant
    ADD CONSTRAINT act_id_tenant_pkey PRIMARY KEY (id_);


--
-- TOC entry 4213 (class 2606 OID 15355591)
-- Name: act_id_user act_id_user_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_id_user
    ADD CONSTRAINT act_id_user_pkey PRIMARY KEY (id_);


--
-- TOC entry 4229 (class 2606 OID 15355651)
-- Name: act_re_case_def act_re_case_def_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_re_case_def
    ADD CONSTRAINT act_re_case_def_pkey PRIMARY KEY (id_);


--
-- TOC entry 4257 (class 2606 OID 15355757)
-- Name: act_re_decision_def act_re_decision_def_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_re_decision_def
    ADD CONSTRAINT act_re_decision_def_pkey PRIMARY KEY (id_);


--
-- TOC entry 4260 (class 2606 OID 15355765)
-- Name: act_re_decision_req_def act_re_decision_req_def_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_re_decision_req_def
    ADD CONSTRAINT act_re_decision_req_def_pkey PRIMARY KEY (id_);


--
-- TOC entry 3988 (class 2606 OID 15355055)
-- Name: act_re_deployment act_re_deployment_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_re_deployment
    ADD CONSTRAINT act_re_deployment_pkey PRIMARY KEY (id_);


--
-- TOC entry 4015 (class 2606 OID 15355090)
-- Name: act_re_procdef act_re_procdef_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_re_procdef
    ADD CONSTRAINT act_re_procdef_pkey PRIMARY KEY (id_);


--
-- TOC entry 4062 (class 2606 OID 15355138)
-- Name: act_ru_authorization act_ru_authorization_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_authorization
    ADD CONSTRAINT act_ru_authorization_pkey PRIMARY KEY (id_);


--
-- TOC entry 4087 (class 2606 OID 15355169)
-- Name: act_ru_batch act_ru_batch_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_batch
    ADD CONSTRAINT act_ru_batch_pkey PRIMARY KEY (id_);


--
-- TOC entry 4236 (class 2606 OID 15355659)
-- Name: act_ru_case_execution act_ru_case_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_case_execution
    ADD CONSTRAINT act_ru_case_execution_pkey PRIMARY KEY (id_);


--
-- TOC entry 4240 (class 2606 OID 15355667)
-- Name: act_ru_case_sentry_part act_ru_case_sentry_part_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_case_sentry_part
    ADD CONSTRAINT act_ru_case_sentry_part_pkey PRIMARY KEY (id_);


--
-- TOC entry 4048 (class 2606 OID 15355122)
-- Name: act_ru_event_subscr act_ru_event_subscr_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_event_subscr
    ADD CONSTRAINT act_ru_event_subscr_pkey PRIMARY KEY (id_);


--
-- TOC entry 3997 (class 2606 OID 15355063)
-- Name: act_ru_execution act_ru_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_execution
    ADD CONSTRAINT act_ru_execution_pkey PRIMARY KEY (id_);


--
-- TOC entry 4082 (class 2606 OID 15355161)
-- Name: act_ru_ext_task act_ru_ext_task_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_ext_task
    ADD CONSTRAINT act_ru_ext_task_pkey PRIMARY KEY (id_);


--
-- TOC entry 4068 (class 2606 OID 15355146)
-- Name: act_ru_filter act_ru_filter_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_filter
    ADD CONSTRAINT act_ru_filter_pkey PRIMARY KEY (id_);


--
-- TOC entry 4031 (class 2606 OID 15355106)
-- Name: act_ru_identitylink act_ru_identitylink_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_identitylink
    ADD CONSTRAINT act_ru_identitylink_pkey PRIMARY KEY (id_);


--
-- TOC entry 4058 (class 2606 OID 15355130)
-- Name: act_ru_incident act_ru_incident_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_incident
    ADD CONSTRAINT act_ru_incident_pkey PRIMARY KEY (id_);


--
-- TOC entry 4006 (class 2606 OID 15355073)
-- Name: act_ru_job act_ru_job_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_job
    ADD CONSTRAINT act_ru_job_pkey PRIMARY KEY (id_);


--
-- TOC entry 4010 (class 2606 OID 15355081)
-- Name: act_ru_jobdef act_ru_jobdef_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_jobdef
    ADD CONSTRAINT act_ru_jobdef_pkey PRIMARY KEY (id_);


--
-- TOC entry 4075 (class 2606 OID 15355152)
-- Name: act_ru_meter_log act_ru_meter_log_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_meter_log
    ADD CONSTRAINT act_ru_meter_log_pkey PRIMARY KEY (id_);


--
-- TOC entry 4025 (class 2606 OID 15355098)
-- Name: act_ru_task act_ru_task_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_task
    ADD CONSTRAINT act_ru_task_pkey PRIMARY KEY (id_);


--
-- TOC entry 4040 (class 2606 OID 15355114)
-- Name: act_ru_variable act_ru_variable_pkey; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_variable
    ADD CONSTRAINT act_ru_variable_pkey PRIMARY KEY (id_);


--
-- TOC entry 4064 (class 2606 OID 15355324)
-- Name: act_ru_authorization act_uniq_auth_group; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_authorization
    ADD CONSTRAINT act_uniq_auth_group UNIQUE (type_, group_id_, resource_type_, resource_id_);


--
-- TOC entry 4066 (class 2606 OID 15355322)
-- Name: act_ru_authorization act_uniq_auth_user; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_authorization
    ADD CONSTRAINT act_uniq_auth_user UNIQUE (type_, user_id_, resource_type_, resource_id_);


--
-- TOC entry 4224 (class 2606 OID 15355625)
-- Name: act_id_tenant_member act_uniq_tenant_memb_group; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_id_tenant_member
    ADD CONSTRAINT act_uniq_tenant_memb_group UNIQUE (tenant_id_, group_id_);


--
-- TOC entry 4226 (class 2606 OID 15355623)
-- Name: act_id_tenant_member act_uniq_tenant_memb_user; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_id_tenant_member
    ADD CONSTRAINT act_uniq_tenant_memb_user UNIQUE (tenant_id_, user_id_);


--
-- TOC entry 4042 (class 2606 OID 15355326)
-- Name: act_ru_variable act_uniq_variable; Type: CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_variable
    ADD CONSTRAINT act_uniq_variable UNIQUE (var_scope_, name_);


--
-- TOC entry 4295 (class 2606 OID 16507279)
-- Name: cases cases_pkey; Type: CONSTRAINT; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY unemployment_service.cases
    ADD CONSTRAINT cases_pkey PRIMARY KEY (id_case, id_social_worker, id_user, id_employer);


--
-- TOC entry 4293 (class 2606 OID 16507257)
-- Name: employers employers_pkey; Type: CONSTRAINT; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY unemployment_service.employers
    ADD CONSTRAINT employers_pkey PRIMARY KEY (id_employer);


--
-- TOC entry 4289 (class 2606 OID 16507238)
-- Name: social_worker social_worker_pkey; Type: CONSTRAINT; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY unemployment_service.social_worker
    ADD CONSTRAINT social_worker_pkey PRIMARY KEY (id_social_worker);


--
-- TOC entry 4291 (class 2606 OID 16507249)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY unemployment_service.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id_user);


--
-- TOC entry 4194 (class 1259 OID 15355548)
-- Name: act_hi_bat_rm_time; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_hi_bat_rm_time ON public.act_hi_batch USING btree (removal_time_);


--
-- TOC entry 4199 (class 1259 OID 15355552)
-- Name: act_hi_ext_task_log_proc_def_key; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_hi_ext_task_log_proc_def_key ON public.act_hi_ext_task_log USING btree (proc_def_key_);


--
-- TOC entry 4200 (class 1259 OID 15355551)
-- Name: act_hi_ext_task_log_procdef; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_hi_ext_task_log_procdef ON public.act_hi_ext_task_log USING btree (proc_def_id_);


--
-- TOC entry 4201 (class 1259 OID 15355550)
-- Name: act_hi_ext_task_log_procinst; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_hi_ext_task_log_procinst ON public.act_hi_ext_task_log USING btree (proc_inst_id_);


--
-- TOC entry 4202 (class 1259 OID 15355555)
-- Name: act_hi_ext_task_log_rm_time; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_hi_ext_task_log_rm_time ON public.act_hi_ext_task_log USING btree (removal_time_);


--
-- TOC entry 4203 (class 1259 OID 15355549)
-- Name: act_hi_ext_task_log_root_pi; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_hi_ext_task_log_root_pi ON public.act_hi_ext_task_log USING btree (root_proc_inst_id_);


--
-- TOC entry 4204 (class 1259 OID 15355553)
-- Name: act_hi_ext_task_log_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_hi_ext_task_log_tenant_id ON public.act_hi_ext_task_log USING btree (tenant_id_);


--
-- TOC entry 4026 (class 1259 OID 15355236)
-- Name: act_idx_athrz_procedef; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_athrz_procedef ON public.act_ru_identitylink USING btree (proc_def_id_);


--
-- TOC entry 4059 (class 1259 OID 15355198)
-- Name: act_idx_auth_group_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_auth_group_id ON public.act_ru_authorization USING btree (group_id_);


--
-- TOC entry 4060 (class 1259 OID 15355360)
-- Name: act_idx_auth_resource_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_auth_resource_id ON public.act_ru_authorization USING btree (resource_id_);


--
-- TOC entry 4083 (class 1259 OID 15355344)
-- Name: act_idx_batch_job_def; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_batch_job_def ON public.act_ru_batch USING btree (batch_job_def_id_);


--
-- TOC entry 4084 (class 1259 OID 15355338)
-- Name: act_idx_batch_monitor_job_def; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_batch_monitor_job_def ON public.act_ru_batch USING btree (monitor_job_def_id_);


--
-- TOC entry 4085 (class 1259 OID 15355332)
-- Name: act_idx_batch_seed_job_def; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_batch_seed_job_def ON public.act_ru_batch USING btree (seed_job_def_id_);


--
-- TOC entry 3981 (class 1259 OID 15355200)
-- Name: act_idx_bytear_depl; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_bytear_depl ON public.act_ge_bytearray USING btree (deployment_id_);


--
-- TOC entry 3982 (class 1259 OID 15355364)
-- Name: act_idx_bytearray_name; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_bytearray_name ON public.act_ge_bytearray USING btree (name_);


--
-- TOC entry 3983 (class 1259 OID 15355363)
-- Name: act_idx_bytearray_rm_time; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_bytearray_rm_time ON public.act_ge_bytearray USING btree (removal_time_);


--
-- TOC entry 3984 (class 1259 OID 15355362)
-- Name: act_idx_bytearray_root_pi; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_bytearray_root_pi ON public.act_ge_bytearray USING btree (root_proc_inst_id_);


--
-- TOC entry 4227 (class 1259 OID 15355723)
-- Name: act_idx_case_def_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_case_def_tenant_id ON public.act_re_case_def USING btree (tenant_id_);


--
-- TOC entry 4230 (class 1259 OID 15355681)
-- Name: act_idx_case_exe_case_def; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_case_exe_case_def ON public.act_ru_case_execution USING btree (case_def_id_);


--
-- TOC entry 4231 (class 1259 OID 15355669)
-- Name: act_idx_case_exe_case_inst; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_case_exe_case_inst ON public.act_ru_case_execution USING btree (case_inst_id_);


--
-- TOC entry 4232 (class 1259 OID 15355675)
-- Name: act_idx_case_exe_parent; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_case_exe_parent ON public.act_ru_case_execution USING btree (parent_id_);


--
-- TOC entry 4233 (class 1259 OID 15355668)
-- Name: act_idx_case_exec_buskey; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_case_exec_buskey ON public.act_ru_case_execution USING btree (business_key_);


--
-- TOC entry 4234 (class 1259 OID 15355724)
-- Name: act_idx_case_exec_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_case_exec_tenant_id ON public.act_ru_case_execution USING btree (tenant_id_);


--
-- TOC entry 4237 (class 1259 OID 15355717)
-- Name: act_idx_case_sentry_case_exec; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_case_sentry_case_exec ON public.act_ru_case_sentry_part USING btree (case_exec_id_);


--
-- TOC entry 4238 (class 1259 OID 15355711)
-- Name: act_idx_case_sentry_case_inst; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_case_sentry_case_inst ON public.act_ru_case_sentry_part USING btree (case_inst_id_);


--
-- TOC entry 4254 (class 1259 OID 15355772)
-- Name: act_idx_dec_def_req_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_dec_def_req_id ON public.act_re_decision_def USING btree (dec_req_id_);


--
-- TOC entry 4255 (class 1259 OID 15355771)
-- Name: act_idx_dec_def_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_dec_def_tenant_id ON public.act_re_decision_def USING btree (tenant_id_);


--
-- TOC entry 4258 (class 1259 OID 15355773)
-- Name: act_idx_dec_req_def_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_dec_req_def_tenant_id ON public.act_re_decision_req_def USING btree (tenant_id_);


--
-- TOC entry 3985 (class 1259 OID 15355365)
-- Name: act_idx_deployment_name; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_deployment_name ON public.act_re_deployment USING btree (name_);


--
-- TOC entry 3986 (class 1259 OID 15355366)
-- Name: act_idx_deployment_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_deployment_tenant_id ON public.act_re_deployment USING btree (tenant_id_);


--
-- TOC entry 4043 (class 1259 OID 15355284)
-- Name: act_idx_event_subscr; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_event_subscr ON public.act_ru_event_subscr USING btree (execution_id_);


--
-- TOC entry 4044 (class 1259 OID 15355178)
-- Name: act_idx_event_subscr_config_; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_event_subscr_config_ ON public.act_ru_event_subscr USING btree (configuration_);


--
-- TOC entry 4045 (class 1259 OID 15355369)
-- Name: act_idx_event_subscr_evt_name; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_event_subscr_evt_name ON public.act_ru_event_subscr USING btree (event_name_);


--
-- TOC entry 4046 (class 1259 OID 15355179)
-- Name: act_idx_event_subscr_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_event_subscr_tenant_id ON public.act_ru_event_subscr USING btree (tenant_id_);


--
-- TOC entry 3989 (class 1259 OID 15355212)
-- Name: act_idx_exe_parent; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_exe_parent ON public.act_ru_execution USING btree (parent_id_);


--
-- TOC entry 3990 (class 1259 OID 15355224)
-- Name: act_idx_exe_procdef; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_exe_procdef ON public.act_ru_execution USING btree (proc_def_id_);


--
-- TOC entry 3991 (class 1259 OID 15355206)
-- Name: act_idx_exe_procinst; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_exe_procinst ON public.act_ru_execution USING btree (proc_inst_id_);


--
-- TOC entry 3992 (class 1259 OID 15355170)
-- Name: act_idx_exe_root_pi; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_exe_root_pi ON public.act_ru_execution USING btree (root_proc_inst_id_);


--
-- TOC entry 3993 (class 1259 OID 15355218)
-- Name: act_idx_exe_super; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_exe_super ON public.act_ru_execution USING btree (super_exec_);


--
-- TOC entry 3994 (class 1259 OID 15355171)
-- Name: act_idx_exec_buskey; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_exec_buskey ON public.act_ru_execution USING btree (business_key_);


--
-- TOC entry 3995 (class 1259 OID 15355172)
-- Name: act_idx_exec_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_exec_tenant_id ON public.act_ru_execution USING btree (tenant_id_);


--
-- TOC entry 4076 (class 1259 OID 15355197)
-- Name: act_idx_ext_task_err_details; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_ext_task_err_details ON public.act_ru_ext_task USING btree (error_details_id_);


--
-- TOC entry 4077 (class 1259 OID 15355361)
-- Name: act_idx_ext_task_exec; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_ext_task_exec ON public.act_ru_ext_task USING btree (execution_id_);


--
-- TOC entry 4078 (class 1259 OID 15355196)
-- Name: act_idx_ext_task_priority; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_ext_task_priority ON public.act_ru_ext_task USING btree (priority_);


--
-- TOC entry 4079 (class 1259 OID 15355195)
-- Name: act_idx_ext_task_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_ext_task_tenant_id ON public.act_ru_ext_task USING btree (tenant_id_);


--
-- TOC entry 4080 (class 1259 OID 15355194)
-- Name: act_idx_ext_task_topic; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_ext_task_topic ON public.act_ru_ext_task USING btree (topic_name_);


--
-- TOC entry 4102 (class 1259 OID 15355493)
-- Name: act_idx_hi_act_inst_comp; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_act_inst_comp ON public.act_hi_actinst USING btree (execution_id_, act_id_, end_time_, id_);


--
-- TOC entry 4103 (class 1259 OID 15355491)
-- Name: act_idx_hi_act_inst_end; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_act_inst_end ON public.act_hi_actinst USING btree (end_time_);


--
-- TOC entry 4104 (class 1259 OID 15355496)
-- Name: act_idx_hi_act_inst_proc_def_key; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_act_inst_proc_def_key ON public.act_hi_actinst USING btree (proc_def_key_);


--
-- TOC entry 4105 (class 1259 OID 15355492)
-- Name: act_idx_hi_act_inst_procinst; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_act_inst_procinst ON public.act_hi_actinst USING btree (proc_inst_id_, act_id_);


--
-- TOC entry 4106 (class 1259 OID 15355498)
-- Name: act_idx_hi_act_inst_rm_time; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_act_inst_rm_time ON public.act_hi_actinst USING btree (removal_time_);


--
-- TOC entry 4107 (class 1259 OID 15355490)
-- Name: act_idx_hi_act_inst_start; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_act_inst_start ON public.act_hi_actinst USING btree (start_time_);


--
-- TOC entry 4108 (class 1259 OID 15355494)
-- Name: act_idx_hi_act_inst_stats; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_act_inst_stats ON public.act_hi_actinst USING btree (proc_def_id_, proc_inst_id_, act_id_, end_time_, act_inst_state_);


--
-- TOC entry 4109 (class 1259 OID 15355495)
-- Name: act_idx_hi_act_inst_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_act_inst_tenant_id ON public.act_hi_actinst USING btree (tenant_id_);


--
-- TOC entry 4110 (class 1259 OID 15355489)
-- Name: act_idx_hi_actinst_root_pi; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_actinst_root_pi ON public.act_hi_actinst USING btree (root_proc_inst_id_);


--
-- TOC entry 4111 (class 1259 OID 15355497)
-- Name: act_idx_hi_ai_pdefid_end_time; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_ai_pdefid_end_time ON public.act_hi_actinst USING btree (proc_def_id_, end_time_);


--
-- TOC entry 4164 (class 1259 OID 15355562)
-- Name: act_idx_hi_attachment_content; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_attachment_content ON public.act_hi_attachment USING btree (content_id_);


--
-- TOC entry 4165 (class 1259 OID 15355564)
-- Name: act_idx_hi_attachment_procinst; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_attachment_procinst ON public.act_hi_attachment USING btree (proc_inst_id_);


--
-- TOC entry 4166 (class 1259 OID 15355566)
-- Name: act_idx_hi_attachment_rm_time; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_attachment_rm_time ON public.act_hi_attachment USING btree (removal_time_);


--
-- TOC entry 4167 (class 1259 OID 15355563)
-- Name: act_idx_hi_attachment_root_pi; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_attachment_root_pi ON public.act_hi_attachment USING btree (root_proc_inst_id_);


--
-- TOC entry 4168 (class 1259 OID 15355565)
-- Name: act_idx_hi_attachment_task; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_attachment_task ON public.act_hi_attachment USING btree (task_id_);


--
-- TOC entry 4250 (class 1259 OID 15355748)
-- Name: act_idx_hi_cas_a_i_comp; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_cas_a_i_comp ON public.act_hi_caseactinst USING btree (case_act_id_, end_time_, id_);


--
-- TOC entry 4251 (class 1259 OID 15355746)
-- Name: act_idx_hi_cas_a_i_create; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_cas_a_i_create ON public.act_hi_caseactinst USING btree (create_time_);


--
-- TOC entry 4252 (class 1259 OID 15355747)
-- Name: act_idx_hi_cas_a_i_end; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_cas_a_i_end ON public.act_hi_caseactinst USING btree (end_time_);


--
-- TOC entry 4253 (class 1259 OID 15355749)
-- Name: act_idx_hi_cas_a_i_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_cas_a_i_tenant_id ON public.act_hi_caseactinst USING btree (tenant_id_);


--
-- TOC entry 4245 (class 1259 OID 15355744)
-- Name: act_idx_hi_cas_i_buskey; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_cas_i_buskey ON public.act_hi_caseinst USING btree (business_key_);


--
-- TOC entry 4246 (class 1259 OID 15355743)
-- Name: act_idx_hi_cas_i_close; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_cas_i_close ON public.act_hi_caseinst USING btree (close_time_);


--
-- TOC entry 4247 (class 1259 OID 15355745)
-- Name: act_idx_hi_cas_i_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_cas_i_tenant_id ON public.act_hi_caseinst USING btree (tenant_id_);


--
-- TOC entry 4124 (class 1259 OID 15355530)
-- Name: act_idx_hi_casevar_case_inst; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_casevar_case_inst ON public.act_hi_varinst USING btree (case_inst_id_);


--
-- TOC entry 4158 (class 1259 OID 15355569)
-- Name: act_idx_hi_comment_procinst; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_comment_procinst ON public.act_hi_comment USING btree (proc_inst_id_);


--
-- TOC entry 4159 (class 1259 OID 15355570)
-- Name: act_idx_hi_comment_rm_time; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_comment_rm_time ON public.act_hi_comment USING btree (removal_time_);


--
-- TOC entry 4160 (class 1259 OID 15355568)
-- Name: act_idx_hi_comment_root_pi; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_comment_root_pi ON public.act_hi_comment USING btree (root_proc_inst_id_);


--
-- TOC entry 4161 (class 1259 OID 15355567)
-- Name: act_idx_hi_comment_task; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_comment_task ON public.act_hi_comment USING btree (task_id_);


--
-- TOC entry 4278 (class 1259 OID 15355812)
-- Name: act_idx_hi_dec_in_clause; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_dec_in_clause ON public.act_hi_dec_in USING btree (dec_inst_id_, clause_id_);


--
-- TOC entry 4279 (class 1259 OID 15355811)
-- Name: act_idx_hi_dec_in_inst; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_dec_in_inst ON public.act_hi_dec_in USING btree (dec_inst_id_);


--
-- TOC entry 4280 (class 1259 OID 15355814)
-- Name: act_idx_hi_dec_in_rm_time; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_dec_in_rm_time ON public.act_hi_dec_in USING btree (removal_time_);


--
-- TOC entry 4281 (class 1259 OID 15355813)
-- Name: act_idx_hi_dec_in_root_pi; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_dec_in_root_pi ON public.act_hi_dec_in USING btree (root_proc_inst_id_);


--
-- TOC entry 4263 (class 1259 OID 15355802)
-- Name: act_idx_hi_dec_inst_act; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_dec_inst_act ON public.act_hi_decinst USING btree (act_id_);


--
-- TOC entry 4264 (class 1259 OID 15355803)
-- Name: act_idx_hi_dec_inst_act_inst; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_dec_inst_act_inst ON public.act_hi_decinst USING btree (act_inst_id_);


--
-- TOC entry 4265 (class 1259 OID 15355801)
-- Name: act_idx_hi_dec_inst_ci; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_dec_inst_ci ON public.act_hi_decinst USING btree (case_inst_id_);


--
-- TOC entry 4266 (class 1259 OID 15355798)
-- Name: act_idx_hi_dec_inst_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_dec_inst_id ON public.act_hi_decinst USING btree (dec_def_id_);


--
-- TOC entry 4267 (class 1259 OID 15355799)
-- Name: act_idx_hi_dec_inst_key; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_dec_inst_key ON public.act_hi_decinst USING btree (dec_def_key_);


--
-- TOC entry 4268 (class 1259 OID 15355800)
-- Name: act_idx_hi_dec_inst_pi; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_dec_inst_pi ON public.act_hi_decinst USING btree (proc_inst_id_);


--
-- TOC entry 4269 (class 1259 OID 15355807)
-- Name: act_idx_hi_dec_inst_req_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_dec_inst_req_id ON public.act_hi_decinst USING btree (dec_req_id_);


--
-- TOC entry 4270 (class 1259 OID 15355808)
-- Name: act_idx_hi_dec_inst_req_key; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_dec_inst_req_key ON public.act_hi_decinst USING btree (dec_req_key_);


--
-- TOC entry 4271 (class 1259 OID 15355810)
-- Name: act_idx_hi_dec_inst_rm_time; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_dec_inst_rm_time ON public.act_hi_decinst USING btree (removal_time_);


--
-- TOC entry 4272 (class 1259 OID 15355806)
-- Name: act_idx_hi_dec_inst_root_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_dec_inst_root_id ON public.act_hi_decinst USING btree (root_dec_inst_id_);


--
-- TOC entry 4273 (class 1259 OID 15355809)
-- Name: act_idx_hi_dec_inst_root_pi; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_dec_inst_root_pi ON public.act_hi_decinst USING btree (root_proc_inst_id_);


--
-- TOC entry 4274 (class 1259 OID 15355805)
-- Name: act_idx_hi_dec_inst_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_dec_inst_tenant_id ON public.act_hi_decinst USING btree (tenant_id_);


--
-- TOC entry 4275 (class 1259 OID 15355804)
-- Name: act_idx_hi_dec_inst_time; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_dec_inst_time ON public.act_hi_decinst USING btree (eval_time_);


--
-- TOC entry 4284 (class 1259 OID 15355815)
-- Name: act_idx_hi_dec_out_inst; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_dec_out_inst ON public.act_hi_dec_out USING btree (dec_inst_id_);


--
-- TOC entry 4285 (class 1259 OID 15355818)
-- Name: act_idx_hi_dec_out_rm_time; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_dec_out_rm_time ON public.act_hi_dec_out USING btree (removal_time_);


--
-- TOC entry 4286 (class 1259 OID 15355817)
-- Name: act_idx_hi_dec_out_root_pi; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_dec_out_root_pi ON public.act_hi_dec_out USING btree (root_proc_inst_id_);


--
-- TOC entry 4287 (class 1259 OID 15355816)
-- Name: act_idx_hi_dec_out_rule; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_dec_out_rule ON public.act_hi_dec_out USING btree (rule_order_, clause_id_);


--
-- TOC entry 4134 (class 1259 OID 15355509)
-- Name: act_idx_hi_detail_act_inst; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_detail_act_inst ON public.act_hi_detail USING btree (act_inst_id_);


--
-- TOC entry 4135 (class 1259 OID 15355517)
-- Name: act_idx_hi_detail_bytear; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_detail_bytear ON public.act_hi_detail USING btree (bytearray_id_);


--
-- TOC entry 4136 (class 1259 OID 15355511)
-- Name: act_idx_hi_detail_case_exec; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_detail_case_exec ON public.act_hi_detail USING btree (case_execution_id_);


--
-- TOC entry 4137 (class 1259 OID 15355510)
-- Name: act_idx_hi_detail_case_inst; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_detail_case_inst ON public.act_hi_detail USING btree (case_inst_id_);


--
-- TOC entry 4138 (class 1259 OID 15355513)
-- Name: act_idx_hi_detail_name; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_detail_name ON public.act_hi_detail USING btree (name_);


--
-- TOC entry 4139 (class 1259 OID 15355516)
-- Name: act_idx_hi_detail_proc_def_key; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_detail_proc_def_key ON public.act_hi_detail USING btree (proc_def_key_);


--
-- TOC entry 4140 (class 1259 OID 15355508)
-- Name: act_idx_hi_detail_proc_inst; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_detail_proc_inst ON public.act_hi_detail USING btree (proc_inst_id_);


--
-- TOC entry 4141 (class 1259 OID 15355518)
-- Name: act_idx_hi_detail_rm_time; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_detail_rm_time ON public.act_hi_detail USING btree (removal_time_);


--
-- TOC entry 4142 (class 1259 OID 15355507)
-- Name: act_idx_hi_detail_root_pi; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_detail_root_pi ON public.act_hi_detail USING btree (root_proc_inst_id_);


--
-- TOC entry 4143 (class 1259 OID 15355519)
-- Name: act_idx_hi_detail_task_bytear; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_detail_task_bytear ON public.act_hi_detail USING btree (bytearray_id_, task_id_);


--
-- TOC entry 4144 (class 1259 OID 15355514)
-- Name: act_idx_hi_detail_task_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_detail_task_id ON public.act_hi_detail USING btree (task_id_);


--
-- TOC entry 4145 (class 1259 OID 15355515)
-- Name: act_idx_hi_detail_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_detail_tenant_id ON public.act_hi_detail USING btree (tenant_id_);


--
-- TOC entry 4146 (class 1259 OID 15355512)
-- Name: act_idx_hi_detail_time; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_detail_time ON public.act_hi_detail USING btree (time_);


--
-- TOC entry 4205 (class 1259 OID 15355554)
-- Name: act_idx_hi_exttasklog_errordet; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_exttasklog_errordet ON public.act_hi_ext_task_log USING btree (error_details_id_);


--
-- TOC entry 4149 (class 1259 OID 15355526)
-- Name: act_idx_hi_ident_link_rm_time; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_ident_link_rm_time ON public.act_hi_identitylink USING btree (removal_time_);


--
-- TOC entry 4150 (class 1259 OID 15355525)
-- Name: act_idx_hi_ident_link_task; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_ident_link_task ON public.act_hi_identitylink USING btree (task_id_);


--
-- TOC entry 4151 (class 1259 OID 15355522)
-- Name: act_idx_hi_ident_lnk_group; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_ident_lnk_group ON public.act_hi_identitylink USING btree (group_id_);


--
-- TOC entry 4152 (class 1259 OID 15355524)
-- Name: act_idx_hi_ident_lnk_proc_def_key; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_ident_lnk_proc_def_key ON public.act_hi_identitylink USING btree (proc_def_key_);


--
-- TOC entry 4153 (class 1259 OID 15355520)
-- Name: act_idx_hi_ident_lnk_root_pi; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_ident_lnk_root_pi ON public.act_hi_identitylink USING btree (root_proc_inst_id_);


--
-- TOC entry 4154 (class 1259 OID 15355523)
-- Name: act_idx_hi_ident_lnk_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_ident_lnk_tenant_id ON public.act_hi_identitylink USING btree (tenant_id_);


--
-- TOC entry 4155 (class 1259 OID 15355521)
-- Name: act_idx_hi_ident_lnk_user; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_ident_lnk_user ON public.act_hi_identitylink USING btree (user_id_);


--
-- TOC entry 4179 (class 1259 OID 15355536)
-- Name: act_idx_hi_incident_proc_def_key; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_incident_proc_def_key ON public.act_hi_incident USING btree (proc_def_key_);


--
-- TOC entry 4180 (class 1259 OID 15355538)
-- Name: act_idx_hi_incident_procinst; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_incident_procinst ON public.act_hi_incident USING btree (proc_inst_id_);


--
-- TOC entry 4181 (class 1259 OID 15355539)
-- Name: act_idx_hi_incident_rm_time; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_incident_rm_time ON public.act_hi_incident USING btree (removal_time_);


--
-- TOC entry 4182 (class 1259 OID 15355537)
-- Name: act_idx_hi_incident_root_pi; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_incident_root_pi ON public.act_hi_incident USING btree (root_proc_inst_id_);


--
-- TOC entry 4183 (class 1259 OID 15355535)
-- Name: act_idx_hi_incident_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_incident_tenant_id ON public.act_hi_incident USING btree (tenant_id_);


--
-- TOC entry 4186 (class 1259 OID 15355546)
-- Name: act_idx_hi_job_log_ex_stack; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_job_log_ex_stack ON public.act_hi_job_log USING btree (job_exception_stack_id_);


--
-- TOC entry 4187 (class 1259 OID 15355544)
-- Name: act_idx_hi_job_log_job_def_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_job_log_job_def_id ON public.act_hi_job_log USING btree (job_def_id_);


--
-- TOC entry 4188 (class 1259 OID 15355545)
-- Name: act_idx_hi_job_log_proc_def_key; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_job_log_proc_def_key ON public.act_hi_job_log USING btree (process_def_key_);


--
-- TOC entry 4189 (class 1259 OID 15355542)
-- Name: act_idx_hi_job_log_procdef; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_job_log_procdef ON public.act_hi_job_log USING btree (process_def_id_);


--
-- TOC entry 4190 (class 1259 OID 15355541)
-- Name: act_idx_hi_job_log_procinst; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_job_log_procinst ON public.act_hi_job_log USING btree (process_instance_id_);


--
-- TOC entry 4191 (class 1259 OID 15355547)
-- Name: act_idx_hi_job_log_rm_time; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_job_log_rm_time ON public.act_hi_job_log USING btree (removal_time_);


--
-- TOC entry 4192 (class 1259 OID 15355540)
-- Name: act_idx_hi_job_log_root_pi; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_job_log_root_pi ON public.act_hi_job_log USING btree (root_proc_inst_id_);


--
-- TOC entry 4193 (class 1259 OID 15355543)
-- Name: act_idx_hi_job_log_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_job_log_tenant_id ON public.act_hi_job_log USING btree (tenant_id_);


--
-- TOC entry 4171 (class 1259 OID 15355558)
-- Name: act_idx_hi_op_log_procdef; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_op_log_procdef ON public.act_hi_op_log USING btree (proc_def_id_);


--
-- TOC entry 4172 (class 1259 OID 15355557)
-- Name: act_idx_hi_op_log_procinst; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_op_log_procinst ON public.act_hi_op_log USING btree (proc_inst_id_);


--
-- TOC entry 4173 (class 1259 OID 15355560)
-- Name: act_idx_hi_op_log_rm_time; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_op_log_rm_time ON public.act_hi_op_log USING btree (removal_time_);


--
-- TOC entry 4174 (class 1259 OID 15355556)
-- Name: act_idx_hi_op_log_root_pi; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_op_log_root_pi ON public.act_hi_op_log USING btree (root_proc_inst_id_);


--
-- TOC entry 4175 (class 1259 OID 15355559)
-- Name: act_idx_hi_op_log_task; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_op_log_task ON public.act_hi_op_log USING btree (task_id_);


--
-- TOC entry 4176 (class 1259 OID 15355561)
-- Name: act_idx_hi_op_log_timestamp; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_op_log_timestamp ON public.act_hi_op_log USING btree (timestamp_);


--
-- TOC entry 4092 (class 1259 OID 15355486)
-- Name: act_idx_hi_pi_pdefid_end_time; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_pi_pdefid_end_time ON public.act_hi_procinst USING btree (proc_def_id_, end_time_);


--
-- TOC entry 4093 (class 1259 OID 15355482)
-- Name: act_idx_hi_pro_i_buskey; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_pro_i_buskey ON public.act_hi_procinst USING btree (business_key_);


--
-- TOC entry 4094 (class 1259 OID 15355481)
-- Name: act_idx_hi_pro_inst_end; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_pro_inst_end ON public.act_hi_procinst USING btree (end_time_);


--
-- TOC entry 4095 (class 1259 OID 15355484)
-- Name: act_idx_hi_pro_inst_proc_def_key; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_pro_inst_proc_def_key ON public.act_hi_procinst USING btree (proc_def_key_);


--
-- TOC entry 4096 (class 1259 OID 15355485)
-- Name: act_idx_hi_pro_inst_proc_time; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_pro_inst_proc_time ON public.act_hi_procinst USING btree (start_time_, end_time_);


--
-- TOC entry 4097 (class 1259 OID 15355488)
-- Name: act_idx_hi_pro_inst_rm_time; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_pro_inst_rm_time ON public.act_hi_procinst USING btree (removal_time_);


--
-- TOC entry 4098 (class 1259 OID 15355487)
-- Name: act_idx_hi_pro_inst_root_pi; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_pro_inst_root_pi ON public.act_hi_procinst USING btree (root_proc_inst_id_);


--
-- TOC entry 4099 (class 1259 OID 15355483)
-- Name: act_idx_hi_pro_inst_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_pro_inst_tenant_id ON public.act_hi_procinst USING btree (tenant_id_);


--
-- TOC entry 4125 (class 1259 OID 15355529)
-- Name: act_idx_hi_procvar_name_type; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_procvar_name_type ON public.act_hi_varinst USING btree (name_, var_type_);


--
-- TOC entry 4126 (class 1259 OID 15355528)
-- Name: act_idx_hi_procvar_proc_inst; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_procvar_proc_inst ON public.act_hi_varinst USING btree (proc_inst_id_);


--
-- TOC entry 4114 (class 1259 OID 15355506)
-- Name: act_idx_hi_task_inst_end; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_task_inst_end ON public.act_hi_taskinst USING btree (end_time_);


--
-- TOC entry 4115 (class 1259 OID 15355501)
-- Name: act_idx_hi_task_inst_proc_def_key; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_task_inst_proc_def_key ON public.act_hi_taskinst USING btree (proc_def_key_);


--
-- TOC entry 4116 (class 1259 OID 15355504)
-- Name: act_idx_hi_task_inst_rm_time; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_task_inst_rm_time ON public.act_hi_taskinst USING btree (removal_time_);


--
-- TOC entry 4117 (class 1259 OID 15355505)
-- Name: act_idx_hi_task_inst_start; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_task_inst_start ON public.act_hi_taskinst USING btree (start_time_);


--
-- TOC entry 4118 (class 1259 OID 15355500)
-- Name: act_idx_hi_task_inst_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_task_inst_tenant_id ON public.act_hi_taskinst USING btree (tenant_id_);


--
-- TOC entry 4119 (class 1259 OID 15355502)
-- Name: act_idx_hi_taskinst_procinst; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_taskinst_procinst ON public.act_hi_taskinst USING btree (proc_inst_id_);


--
-- TOC entry 4120 (class 1259 OID 15355499)
-- Name: act_idx_hi_taskinst_root_pi; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_taskinst_root_pi ON public.act_hi_taskinst USING btree (root_proc_inst_id_);


--
-- TOC entry 4121 (class 1259 OID 15355503)
-- Name: act_idx_hi_taskinstid_procinst; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_taskinstid_procinst ON public.act_hi_taskinst USING btree (id_, proc_inst_id_);


--
-- TOC entry 4127 (class 1259 OID 15355532)
-- Name: act_idx_hi_var_inst_proc_def_key; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_var_inst_proc_def_key ON public.act_hi_varinst USING btree (proc_def_key_);


--
-- TOC entry 4128 (class 1259 OID 15355531)
-- Name: act_idx_hi_var_inst_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_var_inst_tenant_id ON public.act_hi_varinst USING btree (tenant_id_);


--
-- TOC entry 4129 (class 1259 OID 15355533)
-- Name: act_idx_hi_varinst_bytear; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_varinst_bytear ON public.act_hi_varinst USING btree (bytearray_id_);


--
-- TOC entry 4130 (class 1259 OID 15355534)
-- Name: act_idx_hi_varinst_rm_time; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_varinst_rm_time ON public.act_hi_varinst USING btree (removal_time_);


--
-- TOC entry 4131 (class 1259 OID 15355527)
-- Name: act_idx_hi_varinst_root_pi; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_hi_varinst_root_pi ON public.act_hi_varinst USING btree (root_proc_inst_id_);


--
-- TOC entry 4027 (class 1259 OID 15355177)
-- Name: act_idx_ident_lnk_group; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_ident_lnk_group ON public.act_ru_identitylink USING btree (group_id_);


--
-- TOC entry 4028 (class 1259 OID 15355176)
-- Name: act_idx_ident_lnk_user; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_ident_lnk_user ON public.act_ru_identitylink USING btree (user_id_);


--
-- TOC entry 4049 (class 1259 OID 15355355)
-- Name: act_idx_inc_causeincid; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_inc_causeincid ON public.act_ru_incident USING btree (cause_incident_id_);


--
-- TOC entry 4050 (class 1259 OID 15355182)
-- Name: act_idx_inc_configuration; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_inc_configuration ON public.act_ru_incident USING btree (configuration_);


--
-- TOC entry 4051 (class 1259 OID 15355356)
-- Name: act_idx_inc_exid; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_inc_exid ON public.act_ru_incident USING btree (execution_id_);


--
-- TOC entry 4052 (class 1259 OID 15355315)
-- Name: act_idx_inc_job_def; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_inc_job_def ON public.act_ru_incident USING btree (job_def_id_);


--
-- TOC entry 4053 (class 1259 OID 15355357)
-- Name: act_idx_inc_procdefid; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_inc_procdefid ON public.act_ru_incident USING btree (proc_def_id_);


--
-- TOC entry 4054 (class 1259 OID 15355358)
-- Name: act_idx_inc_procinstid; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_inc_procinstid ON public.act_ru_incident USING btree (proc_inst_id_);


--
-- TOC entry 4055 (class 1259 OID 15355359)
-- Name: act_idx_inc_rootcauseincid; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_inc_rootcauseincid ON public.act_ru_incident USING btree (root_cause_incident_id_);


--
-- TOC entry 4056 (class 1259 OID 15355183)
-- Name: act_idx_inc_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_inc_tenant_id ON public.act_ru_incident USING btree (tenant_id_);


--
-- TOC entry 3998 (class 1259 OID 15355278)
-- Name: act_idx_job_exception; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_job_exception ON public.act_ru_job USING btree (exception_stack_id_);


--
-- TOC entry 3999 (class 1259 OID 15355184)
-- Name: act_idx_job_execution_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_job_execution_id ON public.act_ru_job USING btree (execution_id_);


--
-- TOC entry 4000 (class 1259 OID 15355185)
-- Name: act_idx_job_handler; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_job_handler ON public.act_ru_job USING btree (handler_type_, handler_cfg_);


--
-- TOC entry 4001 (class 1259 OID 15355368)
-- Name: act_idx_job_handler_type; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_job_handler_type ON public.act_ru_job USING btree (handler_type_);


--
-- TOC entry 4002 (class 1259 OID 15355199)
-- Name: act_idx_job_job_def_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_job_job_def_id ON public.act_ru_job USING btree (job_def_id_);


--
-- TOC entry 4003 (class 1259 OID 15355186)
-- Name: act_idx_job_procinst; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_job_procinst ON public.act_ru_job USING btree (process_instance_id_);


--
-- TOC entry 4004 (class 1259 OID 15355187)
-- Name: act_idx_job_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_job_tenant_id ON public.act_ru_job USING btree (tenant_id_);


--
-- TOC entry 4007 (class 1259 OID 15355367)
-- Name: act_idx_jobdef_proc_def_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_jobdef_proc_def_id ON public.act_ru_jobdef USING btree (proc_def_id_);


--
-- TOC entry 4008 (class 1259 OID 15355188)
-- Name: act_idx_jobdef_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_jobdef_tenant_id ON public.act_ru_jobdef USING btree (tenant_id_);


--
-- TOC entry 4210 (class 1259 OID 15355610)
-- Name: act_idx_memb_group; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_memb_group ON public.act_id_membership USING btree (group_id_);


--
-- TOC entry 4211 (class 1259 OID 15355616)
-- Name: act_idx_memb_user; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_memb_user ON public.act_id_membership USING btree (user_id_);


--
-- TOC entry 4069 (class 1259 OID 15355193)
-- Name: act_idx_meter_log; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_meter_log ON public.act_ru_meter_log USING btree (name_, timestamp_);


--
-- TOC entry 4070 (class 1259 OID 15355189)
-- Name: act_idx_meter_log_ms; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_meter_log_ms ON public.act_ru_meter_log USING btree (milliseconds_);


--
-- TOC entry 4071 (class 1259 OID 15355190)
-- Name: act_idx_meter_log_name_ms; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_meter_log_name_ms ON public.act_ru_meter_log USING btree (name_, milliseconds_);


--
-- TOC entry 4072 (class 1259 OID 15355191)
-- Name: act_idx_meter_log_report; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_meter_log_report ON public.act_ru_meter_log USING btree (name_, reporter_, milliseconds_);


--
-- TOC entry 4073 (class 1259 OID 15355192)
-- Name: act_idx_meter_log_time; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_meter_log_time ON public.act_ru_meter_log USING btree (timestamp_);


--
-- TOC entry 4011 (class 1259 OID 15355370)
-- Name: act_idx_procdef_deployment_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_procdef_deployment_id ON public.act_re_procdef USING btree (deployment_id_);


--
-- TOC entry 4012 (class 1259 OID 15355371)
-- Name: act_idx_procdef_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_procdef_tenant_id ON public.act_re_procdef USING btree (tenant_id_);


--
-- TOC entry 4013 (class 1259 OID 15355372)
-- Name: act_idx_procdef_ver_tag; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_procdef_ver_tag ON public.act_re_procdef USING btree (version_tag_);


--
-- TOC entry 4016 (class 1259 OID 15355174)
-- Name: act_idx_task_assignee; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_task_assignee ON public.act_ru_task USING btree (assignee_);


--
-- TOC entry 4017 (class 1259 OID 15355705)
-- Name: act_idx_task_case_def_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_task_case_def_id ON public.act_ru_task USING btree (case_def_id_);


--
-- TOC entry 4018 (class 1259 OID 15355699)
-- Name: act_idx_task_case_exec; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_task_case_exec ON public.act_ru_task USING btree (case_execution_id_);


--
-- TOC entry 4019 (class 1259 OID 15355173)
-- Name: act_idx_task_create; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_task_create ON public.act_ru_task USING btree (create_time_);


--
-- TOC entry 4020 (class 1259 OID 15355242)
-- Name: act_idx_task_exec; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_task_exec ON public.act_ru_task USING btree (execution_id_);


--
-- TOC entry 4021 (class 1259 OID 15355254)
-- Name: act_idx_task_procdef; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_task_procdef ON public.act_ru_task USING btree (proc_def_id_);


--
-- TOC entry 4022 (class 1259 OID 15355248)
-- Name: act_idx_task_procinst; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_task_procinst ON public.act_ru_task USING btree (proc_inst_id_);


--
-- TOC entry 4023 (class 1259 OID 15355175)
-- Name: act_idx_task_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_task_tenant_id ON public.act_ru_task USING btree (tenant_id_);


--
-- TOC entry 4220 (class 1259 OID 15355626)
-- Name: act_idx_tenant_memb; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_tenant_memb ON public.act_id_tenant_member USING btree (tenant_id_);


--
-- TOC entry 4221 (class 1259 OID 15355638)
-- Name: act_idx_tenant_memb_group; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_tenant_memb_group ON public.act_id_tenant_member USING btree (group_id_);


--
-- TOC entry 4222 (class 1259 OID 15355632)
-- Name: act_idx_tenant_memb_user; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_tenant_memb_user ON public.act_id_tenant_member USING btree (user_id_);


--
-- TOC entry 4029 (class 1259 OID 15355230)
-- Name: act_idx_tskass_task; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_tskass_task ON public.act_ru_identitylink USING btree (task_id_);


--
-- TOC entry 4032 (class 1259 OID 15355272)
-- Name: act_idx_var_bytearray; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_var_bytearray ON public.act_ru_variable USING btree (bytearray_id_);


--
-- TOC entry 4033 (class 1259 OID 15355687)
-- Name: act_idx_var_case_exe; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_var_case_exe ON public.act_ru_variable USING btree (case_execution_id_);


--
-- TOC entry 4034 (class 1259 OID 15355693)
-- Name: act_idx_var_case_inst_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_var_case_inst_id ON public.act_ru_variable USING btree (case_inst_id_);


--
-- TOC entry 4035 (class 1259 OID 15355260)
-- Name: act_idx_var_exe; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_var_exe ON public.act_ru_variable USING btree (execution_id_);


--
-- TOC entry 4036 (class 1259 OID 15355266)
-- Name: act_idx_var_procinst; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_var_procinst ON public.act_ru_variable USING btree (proc_inst_id_);


--
-- TOC entry 4037 (class 1259 OID 15355180)
-- Name: act_idx_variable_task_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_variable_task_id ON public.act_ru_variable USING btree (task_id_);


--
-- TOC entry 4038 (class 1259 OID 15355181)
-- Name: act_idx_variable_tenant_id; Type: INDEX; Schema: public; Owner: hhuzlypknkbcwr
--

CREATE INDEX act_idx_variable_tenant_id ON public.act_ru_variable USING btree (tenant_id_);


--
-- TOC entry 4296 (class 1259 OID 16507297)
-- Name: fk_cases_employers1_idx; Type: INDEX; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE INDEX fk_cases_employers1_idx ON unemployment_service.cases USING btree (id_employer);


--
-- TOC entry 4297 (class 1259 OID 16507295)
-- Name: fk_cases_social_worker1_idx; Type: INDEX; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE INDEX fk_cases_social_worker1_idx ON unemployment_service.cases USING btree (id_social_worker);


--
-- TOC entry 4298 (class 1259 OID 16507296)
-- Name: fk_cases_users1_idx; Type: INDEX; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

CREATE INDEX fk_cases_users1_idx ON unemployment_service.cases USING btree (id_user);


--
-- TOC entry 4311 (class 2606 OID 15355237)
-- Name: act_ru_identitylink act_fk_athrz_procedef; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_identitylink
    ADD CONSTRAINT act_fk_athrz_procedef FOREIGN KEY (proc_def_id_) REFERENCES public.act_re_procdef(id_);


--
-- TOC entry 4328 (class 2606 OID 15355345)
-- Name: act_ru_batch act_fk_batch_job_def; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_batch
    ADD CONSTRAINT act_fk_batch_job_def FOREIGN KEY (batch_job_def_id_) REFERENCES public.act_ru_jobdef(id_);


--
-- TOC entry 4327 (class 2606 OID 15355339)
-- Name: act_ru_batch act_fk_batch_monitor_job_def; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_batch
    ADD CONSTRAINT act_fk_batch_monitor_job_def FOREIGN KEY (monitor_job_def_id_) REFERENCES public.act_ru_jobdef(id_);


--
-- TOC entry 4326 (class 2606 OID 15355333)
-- Name: act_ru_batch act_fk_batch_seed_job_def; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_batch
    ADD CONSTRAINT act_fk_batch_seed_job_def FOREIGN KEY (seed_job_def_id_) REFERENCES public.act_ru_jobdef(id_);


--
-- TOC entry 4299 (class 2606 OID 15355201)
-- Name: act_ge_bytearray act_fk_bytearr_depl; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ge_bytearray
    ADD CONSTRAINT act_fk_bytearr_depl FOREIGN KEY (deployment_id_) REFERENCES public.act_re_deployment(id_);


--
-- TOC entry 4336 (class 2606 OID 15355682)
-- Name: act_ru_case_execution act_fk_case_exe_case_def; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_case_execution
    ADD CONSTRAINT act_fk_case_exe_case_def FOREIGN KEY (case_def_id_) REFERENCES public.act_re_case_def(id_);


--
-- TOC entry 4334 (class 2606 OID 15355670)
-- Name: act_ru_case_execution act_fk_case_exe_case_inst; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_case_execution
    ADD CONSTRAINT act_fk_case_exe_case_inst FOREIGN KEY (case_inst_id_) REFERENCES public.act_ru_case_execution(id_);


--
-- TOC entry 4335 (class 2606 OID 15355676)
-- Name: act_ru_case_execution act_fk_case_exe_parent; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_case_execution
    ADD CONSTRAINT act_fk_case_exe_parent FOREIGN KEY (parent_id_) REFERENCES public.act_ru_case_execution(id_);


--
-- TOC entry 4338 (class 2606 OID 15355718)
-- Name: act_ru_case_sentry_part act_fk_case_sentry_case_exec; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_case_sentry_part
    ADD CONSTRAINT act_fk_case_sentry_case_exec FOREIGN KEY (case_exec_id_) REFERENCES public.act_ru_case_execution(id_);


--
-- TOC entry 4337 (class 2606 OID 15355712)
-- Name: act_ru_case_sentry_part act_fk_case_sentry_case_inst; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_case_sentry_part
    ADD CONSTRAINT act_fk_case_sentry_case_inst FOREIGN KEY (case_inst_id_) REFERENCES public.act_ru_case_execution(id_);


--
-- TOC entry 4339 (class 2606 OID 15355766)
-- Name: act_re_decision_def act_fk_dec_req; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_re_decision_def
    ADD CONSTRAINT act_fk_dec_req FOREIGN KEY (dec_req_id_) REFERENCES public.act_re_decision_req_def(id_);


--
-- TOC entry 4317 (class 2606 OID 15355285)
-- Name: act_ru_event_subscr act_fk_event_exec; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_event_subscr
    ADD CONSTRAINT act_fk_event_exec FOREIGN KEY (execution_id_) REFERENCES public.act_ru_execution(id_);


--
-- TOC entry 4301 (class 2606 OID 15355213)
-- Name: act_ru_execution act_fk_exe_parent; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_execution
    ADD CONSTRAINT act_fk_exe_parent FOREIGN KEY (parent_id_) REFERENCES public.act_ru_execution(id_);


--
-- TOC entry 4303 (class 2606 OID 15355225)
-- Name: act_ru_execution act_fk_exe_procdef; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_execution
    ADD CONSTRAINT act_fk_exe_procdef FOREIGN KEY (proc_def_id_) REFERENCES public.act_re_procdef(id_);


--
-- TOC entry 4300 (class 2606 OID 15355207)
-- Name: act_ru_execution act_fk_exe_procinst; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_execution
    ADD CONSTRAINT act_fk_exe_procinst FOREIGN KEY (proc_inst_id_) REFERENCES public.act_ru_execution(id_);


--
-- TOC entry 4302 (class 2606 OID 15355219)
-- Name: act_ru_execution act_fk_exe_super; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_execution
    ADD CONSTRAINT act_fk_exe_super FOREIGN KEY (super_exec_) REFERENCES public.act_ru_execution(id_);


--
-- TOC entry 4325 (class 2606 OID 15355350)
-- Name: act_ru_ext_task act_fk_ext_task_error_details; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_ext_task
    ADD CONSTRAINT act_fk_ext_task_error_details FOREIGN KEY (error_details_id_) REFERENCES public.act_ge_bytearray(id_);


--
-- TOC entry 4324 (class 2606 OID 15355327)
-- Name: act_ru_ext_task act_fk_ext_task_exe; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_ext_task
    ADD CONSTRAINT act_fk_ext_task_exe FOREIGN KEY (execution_id_) REFERENCES public.act_ru_execution(id_);


--
-- TOC entry 4321 (class 2606 OID 15355305)
-- Name: act_ru_incident act_fk_inc_cause; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_incident
    ADD CONSTRAINT act_fk_inc_cause FOREIGN KEY (cause_incident_id_) REFERENCES public.act_ru_incident(id_);


--
-- TOC entry 4318 (class 2606 OID 15355290)
-- Name: act_ru_incident act_fk_inc_exe; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_incident
    ADD CONSTRAINT act_fk_inc_exe FOREIGN KEY (execution_id_) REFERENCES public.act_ru_execution(id_);


--
-- TOC entry 4323 (class 2606 OID 15355316)
-- Name: act_ru_incident act_fk_inc_job_def; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_incident
    ADD CONSTRAINT act_fk_inc_job_def FOREIGN KEY (job_def_id_) REFERENCES public.act_ru_jobdef(id_);


--
-- TOC entry 4320 (class 2606 OID 15355300)
-- Name: act_ru_incident act_fk_inc_procdef; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_incident
    ADD CONSTRAINT act_fk_inc_procdef FOREIGN KEY (proc_def_id_) REFERENCES public.act_re_procdef(id_);


--
-- TOC entry 4319 (class 2606 OID 15355295)
-- Name: act_ru_incident act_fk_inc_procinst; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_incident
    ADD CONSTRAINT act_fk_inc_procinst FOREIGN KEY (proc_inst_id_) REFERENCES public.act_ru_execution(id_);


--
-- TOC entry 4322 (class 2606 OID 15355310)
-- Name: act_ru_incident act_fk_inc_rcause; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_incident
    ADD CONSTRAINT act_fk_inc_rcause FOREIGN KEY (root_cause_incident_id_) REFERENCES public.act_ru_incident(id_);


--
-- TOC entry 4304 (class 2606 OID 15355279)
-- Name: act_ru_job act_fk_job_exception; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_job
    ADD CONSTRAINT act_fk_job_exception FOREIGN KEY (exception_stack_id_) REFERENCES public.act_ge_bytearray(id_);


--
-- TOC entry 4329 (class 2606 OID 15355611)
-- Name: act_id_membership act_fk_memb_group; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_id_membership
    ADD CONSTRAINT act_fk_memb_group FOREIGN KEY (group_id_) REFERENCES public.act_id_group(id_);


--
-- TOC entry 4330 (class 2606 OID 15355617)
-- Name: act_id_membership act_fk_memb_user; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_id_membership
    ADD CONSTRAINT act_fk_memb_user FOREIGN KEY (user_id_) REFERENCES public.act_id_user(id_);


--
-- TOC entry 4309 (class 2606 OID 15355706)
-- Name: act_ru_task act_fk_task_case_def; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_task
    ADD CONSTRAINT act_fk_task_case_def FOREIGN KEY (case_def_id_) REFERENCES public.act_re_case_def(id_);


--
-- TOC entry 4308 (class 2606 OID 15355700)
-- Name: act_ru_task act_fk_task_case_exe; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_task
    ADD CONSTRAINT act_fk_task_case_exe FOREIGN KEY (case_execution_id_) REFERENCES public.act_ru_case_execution(id_);


--
-- TOC entry 4305 (class 2606 OID 15355243)
-- Name: act_ru_task act_fk_task_exe; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_task
    ADD CONSTRAINT act_fk_task_exe FOREIGN KEY (execution_id_) REFERENCES public.act_ru_execution(id_);


--
-- TOC entry 4307 (class 2606 OID 15355255)
-- Name: act_ru_task act_fk_task_procdef; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_task
    ADD CONSTRAINT act_fk_task_procdef FOREIGN KEY (proc_def_id_) REFERENCES public.act_re_procdef(id_);


--
-- TOC entry 4306 (class 2606 OID 15355249)
-- Name: act_ru_task act_fk_task_procinst; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_task
    ADD CONSTRAINT act_fk_task_procinst FOREIGN KEY (proc_inst_id_) REFERENCES public.act_ru_execution(id_);


--
-- TOC entry 4331 (class 2606 OID 15355627)
-- Name: act_id_tenant_member act_fk_tenant_memb; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_id_tenant_member
    ADD CONSTRAINT act_fk_tenant_memb FOREIGN KEY (tenant_id_) REFERENCES public.act_id_tenant(id_);


--
-- TOC entry 4333 (class 2606 OID 15355639)
-- Name: act_id_tenant_member act_fk_tenant_memb_group; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_id_tenant_member
    ADD CONSTRAINT act_fk_tenant_memb_group FOREIGN KEY (group_id_) REFERENCES public.act_id_group(id_);


--
-- TOC entry 4332 (class 2606 OID 15355633)
-- Name: act_id_tenant_member act_fk_tenant_memb_user; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_id_tenant_member
    ADD CONSTRAINT act_fk_tenant_memb_user FOREIGN KEY (user_id_) REFERENCES public.act_id_user(id_);


--
-- TOC entry 4310 (class 2606 OID 15355231)
-- Name: act_ru_identitylink act_fk_tskass_task; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_identitylink
    ADD CONSTRAINT act_fk_tskass_task FOREIGN KEY (task_id_) REFERENCES public.act_ru_task(id_);


--
-- TOC entry 4314 (class 2606 OID 15355273)
-- Name: act_ru_variable act_fk_var_bytearray; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_variable
    ADD CONSTRAINT act_fk_var_bytearray FOREIGN KEY (bytearray_id_) REFERENCES public.act_ge_bytearray(id_);


--
-- TOC entry 4315 (class 2606 OID 15355688)
-- Name: act_ru_variable act_fk_var_case_exe; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_variable
    ADD CONSTRAINT act_fk_var_case_exe FOREIGN KEY (case_execution_id_) REFERENCES public.act_ru_case_execution(id_);


--
-- TOC entry 4316 (class 2606 OID 15355694)
-- Name: act_ru_variable act_fk_var_case_inst; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_variable
    ADD CONSTRAINT act_fk_var_case_inst FOREIGN KEY (case_inst_id_) REFERENCES public.act_ru_case_execution(id_);


--
-- TOC entry 4312 (class 2606 OID 15355261)
-- Name: act_ru_variable act_fk_var_exe; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_variable
    ADD CONSTRAINT act_fk_var_exe FOREIGN KEY (execution_id_) REFERENCES public.act_ru_execution(id_);


--
-- TOC entry 4313 (class 2606 OID 15355267)
-- Name: act_ru_variable act_fk_var_procinst; Type: FK CONSTRAINT; Schema: public; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY public.act_ru_variable
    ADD CONSTRAINT act_fk_var_procinst FOREIGN KEY (proc_inst_id_) REFERENCES public.act_ru_execution(id_);


--
-- TOC entry 4340 (class 2606 OID 16507290)
-- Name: cases fk_cases_employers1; Type: FK CONSTRAINT; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY unemployment_service.cases
    ADD CONSTRAINT fk_cases_employers1 FOREIGN KEY (id_employer) REFERENCES unemployment_service.employers(id_employer);


--
-- TOC entry 4341 (class 2606 OID 16507285)
-- Name: cases fk_cases_users1; Type: FK CONSTRAINT; Schema: unemployment_service; Owner: hhuzlypknkbcwr
--

ALTER TABLE ONLY unemployment_service.cases
    ADD CONSTRAINT fk_cases_users1 FOREIGN KEY (id_user) REFERENCES unemployment_service.users(id_user);


--
-- TOC entry 4469 (class 0 OID 0)
-- Dependencies: 4468
-- Name: DATABASE de1fvedlli5jkk; Type: ACL; Schema: -; Owner: hhuzlypknkbcwr
--

REVOKE CONNECT,TEMPORARY ON DATABASE de1fvedlli5jkk FROM PUBLIC;


--
-- TOC entry 4470 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: hhuzlypknkbcwr
--

REVOKE ALL ON SCHEMA public FROM postgres;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO hhuzlypknkbcwr;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 4471 (class 0 OID 0)
-- Dependencies: 865
-- Name: LANGUAGE plpgsql; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON LANGUAGE plpgsql TO hhuzlypknkbcwr;


-- Completed on 2019-06-05 23:29:03

--
-- PostgreSQL database dump complete
--

