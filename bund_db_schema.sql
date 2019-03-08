--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.3
-- Dumped by pg_dump version 9.6.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: bund; Type: SCHEMA; Schema: -; Owner: mbue
--

CREATE SCHEMA bund;


ALTER SCHEMA bund OWNER TO mbue;

SET search_path = bund, pg_catalog;

--
-- Name: canonicalize(text); Type: FUNCTION; Schema: bund; Owner: mbue
--

CREATE FUNCTION canonicalize(s text) RETURNS text
    LANGUAGE sql
    AS $$
    SELECT regexp_replace(replace(replace(replace(replace(lower(s), 'ß', 'ss'), 'ü', 'ue'), 'ö', 'oe'), 'ä', 'ae'), '[^a-zA-Z]', '', 'g');
$$;


ALTER FUNCTION bund.canonicalize(s text) OWNER TO mbue;

--
-- Name: insert_ist_aktionaktive(integer, integer); Type: FUNCTION; Schema: bund; Owner: mbue
--

CREATE FUNCTION insert_ist_aktionaktive(subjekt_id integer, objekt_id integer, OUT id integer) RETURNS integer
    LANGUAGE sql
    AS $_$
    WITH ins1 AS (
        INSERT INTO base (discriminator) VALUES ('ist_aktionaktive') RETURNING id AS base_id
    )
    INSERT INTO ist_aktionaktive (id, subjekt_id, objekt_id) SELECT base_id, $1, $2 FROM ins1 RETURNING id;
$_$;


ALTER FUNCTION bund.insert_ist_aktionaktive(subjekt_id integer, objekt_id integer, OUT id integer) OWNER TO mbue;

--
-- Name: insert_ist_aktionsraum(integer, integer); Type: FUNCTION; Schema: bund; Owner: mbue
--

CREATE FUNCTION insert_ist_aktionsraum(subjekt_id integer, objekt_id integer, OUT id integer) RETURNS integer
    LANGUAGE sql
    AS $_$
    WITH ins1 AS (
        INSERT INTO base (discriminator) VALUES ('ist_aktionsraum') RETURNING id AS base_id
    )
    INSERT INTO ist_aktionsraum (id, subjekt_id, objekt_id) SELECT base_id, $1, $2 FROM ins1 RETURNING id;
$_$;


ALTER FUNCTION bund.insert_ist_aktionsraum(subjekt_id integer, objekt_id integer, OUT id integer) OWNER TO mbue;

--
-- Name: insert_ist_autorin(integer, integer); Type: FUNCTION; Schema: bund; Owner: mbue
--

CREATE FUNCTION insert_ist_autorin(subjekt_id integer, objekt_id integer, OUT id integer) RETURNS integer
    LANGUAGE sql
    AS $_$
    WITH ins1 AS (
        INSERT INTO base (discriminator) VALUES ('ist_autorin') RETURNING id AS base_id
    )
    INSERT INTO ist_autorin (id, subjekt_id, objekt_id) SELECT base_id, $1, $2 FROM ins1 RETURNING id;
$_$;


ALTER FUNCTION bund.insert_ist_autorin(subjekt_id integer, objekt_id integer, OUT id integer) OWNER TO mbue;

--
-- Name: insert_ist_mitglied(integer, integer); Type: FUNCTION; Schema: bund; Owner: mbue
--

CREATE FUNCTION insert_ist_mitglied(subjekt_id integer, objekt_id integer, OUT id integer) RETURNS integer
    LANGUAGE sql
    AS $_$
    WITH ins1 AS (
        INSERT INTO base (discriminator) VALUES ('ist_mitglied') RETURNING id AS base_id
    )
    INSERT INTO ist_mitglied (id, subjekt_id, objekt_id) SELECT base_id, $1, $2 FROM ins1 RETURNING id;
$_$;


ALTER FUNCTION bund.insert_ist_mitglied(subjekt_id integer, objekt_id integer, OUT id integer) OWNER TO mbue;

--
-- Name: insert_ist_organisationkontakt(integer, integer); Type: FUNCTION; Schema: bund; Owner: mbue
--

CREATE FUNCTION insert_ist_organisationkontakt(subjekt_id integer, objekt_id integer, OUT id integer) RETURNS integer
    LANGUAGE sql
    AS $_$
    WITH ins1 AS (
        INSERT INTO base (discriminator) VALUES ('ist_organisationkontakt') RETURNING id AS base_id
    )
    INSERT INTO ist_organisationkontakt (id, subjekt_id, objekt_id) SELECT base_id, $1, $2 FROM ins1 RETURNING id;
$_$;


ALTER FUNCTION bund.insert_ist_organisationkontakt(subjekt_id integer, objekt_id integer, OUT id integer) OWNER TO mbue;

--
-- Name: insert_ist_personkontakt(integer, integer); Type: FUNCTION; Schema: bund; Owner: mbue
--

CREATE FUNCTION insert_ist_personkontakt(subjekt_id integer, objekt_id integer, OUT id integer) RETURNS integer
    LANGUAGE sql
    AS $_$
    WITH ins1 AS (
        INSERT INTO base (discriminator) VALUES ('ist_personkontakt') RETURNING id AS base_id
    )
    INSERT INTO ist_personkontakt (id, subjekt_id, objekt_id) SELECT base_id, $1, $2 FROM ins1 RETURNING id;
$_$;


ALTER FUNCTION bund.insert_ist_personkontakt(subjekt_id integer, objekt_id integer, OUT id integer) OWNER TO mbue;

--
-- Name: insert_ist_raumkontakt(integer, integer); Type: FUNCTION; Schema: bund; Owner: mbue
--

CREATE FUNCTION insert_ist_raumkontakt(subjekt_id integer, objekt_id integer, OUT id integer) RETURNS integer
    LANGUAGE sql
    AS $_$
    WITH ins1 AS (
        INSERT INTO base (discriminator) VALUES ('ist_raumkontakt') RETURNING id AS base_id
    )
    INSERT INTO ist_raumkontakt (id, subjekt_id, objekt_id) SELECT base_id, $1, $2 FROM ins1 RETURNING id;
$_$;


ALTER FUNCTION bund.insert_ist_raumkontakt(subjekt_id integer, objekt_id integer, OUT id integer) OWNER TO mbue;

--
-- Name: insert_ist_raumorganisation(integer, integer); Type: FUNCTION; Schema: bund; Owner: mbue
--

CREATE FUNCTION insert_ist_raumorganisation(subjekt_id integer, objekt_id integer, OUT id integer) RETURNS integer
    LANGUAGE sql
    AS $_$
    WITH ins1 AS (
        INSERT INTO base (discriminator) VALUES ('ist_raumorganisation') RETURNING id AS base_id
    )
    INSERT INTO ist_raumorganisation (id, subjekt_id, objekt_id) SELECT base_id, $1, $2 FROM ins1 RETURNING id;
$_$;


ALTER FUNCTION bund.insert_ist_raumorganisation(subjekt_id integer, objekt_id integer, OUT id integer) OWNER TO mbue;

--
-- Name: insert_ist_thema(integer, integer); Type: FUNCTION; Schema: bund; Owner: mbue
--

CREATE FUNCTION insert_ist_thema(subjekt_id integer, objekt_id integer, OUT id integer) RETURNS integer
    LANGUAGE sql
    AS $_$
    WITH ins1 AS (
        INSERT INTO base (discriminator) VALUES ('ist_thema') RETURNING id AS base_id
    )
    INSERT INTO ist_thema (id, subjekt_id, objekt_id) SELECT base_id, $1, $2 FROM ins1 RETURNING id;
$_$;


ALTER FUNCTION bund.insert_ist_thema(subjekt_id integer, objekt_id integer, OUT id integer) OWNER TO mbue;

--
-- Name: insert_ist_unterorganisation(integer, integer); Type: FUNCTION; Schema: bund; Owner: mbue
--

CREATE FUNCTION insert_ist_unterorganisation(subjekt_id integer, objekt_id integer, OUT id integer) RETURNS integer
    LANGUAGE sql
    AS $_$
    WITH ins1 AS (
        INSERT INTO base (discriminator) VALUES ('ist_unterorganisation') RETURNING id AS base_id
    )
    INSERT INTO ist_unterorganisation (id, subjekt_id, objekt_id) SELECT base_id, $1, $2 FROM ins1 RETURNING id;
$_$;


ALTER FUNCTION bund.insert_ist_unterorganisation(subjekt_id integer, objekt_id integer, OUT id integer) OWNER TO mbue;

--
-- Name: insert_thema(character varying); Type: FUNCTION; Schema: bund; Owner: mbue
--

CREATE FUNCTION insert_thema(thema character varying) RETURNS void
    LANGUAGE sql
    AS $_$
    WITH ins1 AS (
        INSERT INTO base (discriminator) VALUES ('thema') RETURNING id AS base_id
    )
    INSERT INTO thema (id, thema) SELECT base_id, $1 FROM ins1;
$_$;


ALTER FUNCTION bund.insert_thema(thema character varying) OWNER TO mbue;

--
-- Name: login(text, text); Type: FUNCTION; Schema: bund; Owner: mbue
--

CREATE FUNCTION login(email text, pass text) RETURNS basic_auth.jwt_token
    LANGUAGE plpgsql
    AS $$
declare
  _role name;
  result basic_auth.jwt_token;
begin
  -- check email and password
  select basic_auth.user_role(email, pass) into _role;
  if _role is null then
    raise invalid_password using message = 'invalid user or password';
  end if;

  select sign(
      row_to_json(r), current_setting('app.jwt_secret')
    ) as token
    from (
      select _role as role, login.email as email,
         extract(epoch from now())::integer + current_setting('app.jwt_expires')::integer as exp
    ) r
    into result;
  return result;
end;
$$;


ALTER FUNCTION bund.login(email text, pass text) OWNER TO mbue;

--
-- Name: person_friendly(text, text); Type: FUNCTION; Schema: bund; Owner: mbue
--

CREATE FUNCTION person_friendly(vorname text, name text) RETURNS text
    LANGUAGE sql
    AS $_$
    select case
        when $1 is null
        then $2
        else $1 || ' ' || $2
    end;
$_$;


ALTER FUNCTION bund.person_friendly(vorname text, name text) OWNER TO mbue;

--
-- Name: person_sortname(text, text); Type: FUNCTION; Schema: bund; Owner: mbue
--

CREATE FUNCTION person_sortname(vorname text, name text) RETURNS text
    LANGUAGE sql
    AS $_$
    select case
        when $1 is null
        then $2
        else $2 || ', ' || $1
    end;
$_$;


ALTER FUNCTION bund.person_sortname(vorname text, name text) OWNER TO mbue;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: adresse; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE adresse (
    id integer NOT NULL,
    base_id integer,
    empfaenger character varying(100) NOT NULL,
    zeile1 character varying(100),
    zeile2 character varying(100),
    ort character varying(100),
    plz character varying(20),
    tel1 character varying(32),
    tel2 character varying(32),
    email character varying(100),
    art character varying(100),
    kommentar text
);


ALTER TABLE adresse OWNER TO mbue;

--
-- Name: adresse_id_seq; Type: SEQUENCE; Schema: bund; Owner: mbue
--

CREATE SEQUENCE adresse_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE adresse_id_seq OWNER TO mbue;

--
-- Name: adresse_id_seq; Type: SEQUENCE OWNED BY; Schema: bund; Owner: mbue
--

ALTER SEQUENCE adresse_id_seq OWNED BY adresse.id;


--
-- Name: aktion; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE aktion (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    rahmenveranstaltung character varying(100),
    zeitraum character varying(100),
    turnus character varying(100),
    fristen text
);


ALTER TABLE aktion OWNER TO mbue;

--
-- Name: identities; Type: SEQUENCE; Schema: bund; Owner: mbue
--

CREATE SEQUENCE identities
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE identities OWNER TO mbue;

--
-- Name: base; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE base (
    id integer DEFAULT nextval('identities'::regclass) NOT NULL,
    datum timestamp with time zone DEFAULT now() NOT NULL,
    discriminator character varying(32) NOT NULL,
    url character varying(256),
    bemerkungen text
);


ALTER TABLE base OWNER TO mbue;

--
-- Name: aktion_view; Type: VIEW; Schema: bund; Owner: mbue
--

CREATE VIEW aktion_view AS
 SELECT base.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    aktion.name,
    aktion.rahmenveranstaltung,
    aktion.zeitraum,
    aktion.turnus,
    aktion.fristen,
    aktion.name AS friendly,
    aktion.name AS sortname
   FROM (base
     JOIN aktion USING (id));


ALTER TABLE aktion_view OWNER TO mbue;

--
-- Name: anwendungsbereich; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE anwendungsbereich (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE anwendungsbereich OWNER TO mbue;

--
-- Name: anwendungsbereich_id_seq; Type: SEQUENCE; Schema: bund; Owner: mbue
--

CREATE SEQUENCE anwendungsbereich_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE anwendungsbereich_id_seq OWNER TO mbue;

--
-- Name: anwendungsbereich_id_seq; Type: SEQUENCE OWNED BY; Schema: bund; Owner: mbue
--

ALTER SEQUENCE anwendungsbereich_id_seq OWNED BY anwendungsbereich.id;


--
-- Name: ist_thema; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE ist_thema (
    id integer NOT NULL,
    subjekt_id integer,
    objekt_id integer
);


ALTER TABLE ist_thema OWNER TO mbue;

--
-- Name: thema; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE thema (
    id integer NOT NULL,
    thema character varying(100) NOT NULL,
    suchhilfe character varying(400)
);


ALTER TABLE thema OWNER TO mbue;

--
-- Name: base_themen_view; Type: VIEW; Schema: bund; Owner: mbue
--

CREATE VIEW base_themen_view AS
 SELECT base.id,
    string_agg((thema.thema)::text, ', '::text) AS themen
   FROM base,
    thema,
    ist_thema
  WHERE ((ist_thema.objekt_id = thema.id) AND (ist_thema.subjekt_id = base.id))
  GROUP BY base.id;


ALTER TABLE base_themen_view OWNER TO mbue;

--
-- Name: inventar; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE inventar (
    id integer NOT NULL,
    bezeichnung character varying(100) NOT NULL,
    lagerung character varying(100),
    anschaffung character varying(100),
    zustaendig character varying(100)
);


ALTER TABLE inventar OWNER TO mbue;

--
-- Name: organisation; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE organisation (
    id integer NOT NULL,
    name character varying(100)
);


ALTER TABLE organisation OWNER TO mbue;

--
-- Name: person; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE person (
    id integer NOT NULL,
    vorname character varying(100),
    name character varying(100),
    titel character varying(20),
    anrede character varying(20),
    kontaktaufnahme character varying(100),
    funktion character varying(100)
);


ALTER TABLE person OWNER TO mbue;

--
-- Name: raum; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE raum (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    groesse_qm character varying(10),
    personenzahl integer,
    verwaltung character varying(100),
    kosten character varying(100),
    lage character varying(120)
);


ALTER TABLE raum OWNER TO mbue;

--
-- Name: ressource; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE ressource (
    id integer NOT NULL,
    titel character varying(100) NOT NULL,
    zielgruppe character varying(100),
    erstellungsdatum character varying(32)
);


ALTER TABLE ressource OWNER TO mbue;

--
-- Name: base_view; Type: VIEW; Schema: bund; Owner: mbue
--

CREATE VIEW base_view AS
 SELECT base.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    organisation.name AS friendly,
    canonicalize((organisation.name)::text) AS canonical,
    organisation.name AS sortname
   FROM (base
     JOIN organisation USING (id))
UNION ALL
 SELECT base.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    person_friendly((person.vorname)::text, (person.name)::text) AS friendly,
    ((canonicalize((person.name)::text) || ','::text) || canonicalize((person.vorname)::text)) AS canonical,
    person_sortname((person.vorname)::text, (person.name)::text) AS sortname
   FROM (base
     JOIN person USING (id))
UNION ALL
 SELECT base.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    thema.thema AS friendly,
    canonicalize((thema.thema)::text) AS canonical,
    thema.thema AS sortname
   FROM (base
     JOIN thema USING (id))
UNION ALL
 SELECT base.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    aktion.name AS friendly,
    canonicalize((aktion.name)::text) AS canonical,
    aktion.name AS sortname
   FROM (base
     JOIN aktion USING (id))
UNION ALL
 SELECT base.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    ressource.titel AS friendly,
    canonicalize((ressource.titel)::text) AS canonical,
    ressource.titel AS sortname
   FROM (base
     JOIN ressource USING (id))
UNION ALL
 SELECT base.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    inventar.bezeichnung AS friendly,
    canonicalize((inventar.bezeichnung)::text) AS canonical,
    inventar.bezeichnung AS sortname
   FROM (base
     JOIN inventar USING (id))
UNION ALL
 SELECT base.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    raum.name AS friendly,
    canonicalize((raum.name)::text) AS canonical,
    raum.name AS sortname
   FROM (base
     JOIN raum USING (id));


ALTER TABLE base_view OWNER TO mbue;

--
-- Name: eignung; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE eignung (
    id integer NOT NULL,
    eignung character varying(100) NOT NULL
);


ALTER TABLE eignung OWNER TO mbue;

--
-- Name: eignung_id_seq; Type: SEQUENCE; Schema: bund; Owner: mbue
--

CREATE SEQUENCE eignung_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE eignung_id_seq OWNER TO mbue;

--
-- Name: eignung_id_seq; Type: SEQUENCE OWNED BY; Schema: bund; Owner: mbue
--

ALTER SEQUENCE eignung_id_seq OWNED BY eignung.id;


--
-- Name: f_ziel; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE f_ziel (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE f_ziel OWNER TO mbue;

--
-- Name: f_ziel_id_seq; Type: SEQUENCE; Schema: bund; Owner: mbue
--

CREATE SEQUENCE f_ziel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE f_ziel_id_seq OWNER TO mbue;

--
-- Name: f_ziel_id_seq; Type: SEQUENCE OWNED BY; Schema: bund; Owner: mbue
--

ALTER SEQUENCE f_ziel_id_seq OWNED BY f_ziel.id;


--
-- Name: film; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE film (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    jahr character varying(10),
    einschaetzung character varying(400),
    zielgruppe character varying(100),
    verfuegbarkeit character varying(100)
);


ALTER TABLE film OWNER TO mbue;

--
-- Name: foerderung; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE foerderung (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    fristen character varying(400)
);


ALTER TABLE foerderung OWNER TO mbue;

--
-- Name: historie; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE historie (
    id integer NOT NULL,
    base_id integer,
    datum timestamp with time zone DEFAULT now() NOT NULL,
    notiz text NOT NULL,
    username text DEFAULT current_setting('request.jwt.claim.email'::text)
);


ALTER TABLE historie OWNER TO mbue;

--
-- Name: historie_id_seq; Type: SEQUENCE; Schema: bund; Owner: mbue
--

CREATE SEQUENCE historie_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE historie_id_seq OWNER TO mbue;

--
-- Name: historie_id_seq; Type: SEQUENCE OWNED BY; Schema: bund; Owner: mbue
--

ALTER SEQUENCE historie_id_seq OWNED BY historie.id;


--
-- Name: inventar_view; Type: VIEW; Schema: bund; Owner: mbue
--

CREATE VIEW inventar_view AS
 SELECT base.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    inventar.bezeichnung,
    inventar.lagerung,
    inventar.anschaffung,
    inventar.zustaendig,
    inventar.bezeichnung AS friendly,
    inventar.bezeichnung AS sortname
   FROM (base
     JOIN inventar USING (id));


ALTER TABLE inventar_view OWNER TO mbue;

--
-- Name: inventarkategorie; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE inventarkategorie (
    inventar_id integer NOT NULL,
    kategorie_id integer NOT NULL
);


ALTER TABLE inventarkategorie OWNER TO mbue;

--
-- Name: ist_aktionaktive; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE ist_aktionaktive (
    id integer NOT NULL,
    subjekt_id integer,
    objekt_id integer
);


ALTER TABLE ist_aktionaktive OWNER TO mbue;

--
-- Name: ist_aktionsraum; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE ist_aktionsraum (
    id integer NOT NULL,
    subjekt_id integer,
    objekt_id integer
);


ALTER TABLE ist_aktionsraum OWNER TO mbue;

--
-- Name: ist_autorin; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE ist_autorin (
    id integer NOT NULL,
    subjekt_id integer,
    objekt_id integer
);


ALTER TABLE ist_autorin OWNER TO mbue;

--
-- Name: ist_mitglied; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE ist_mitglied (
    id integer NOT NULL,
    subjekt_id integer,
    objekt_id integer
);


ALTER TABLE ist_mitglied OWNER TO mbue;

--
-- Name: ist_organisationkontakt; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE ist_organisationkontakt (
    id integer NOT NULL,
    subjekt_id integer,
    objekt_id integer
);


ALTER TABLE ist_organisationkontakt OWNER TO mbue;

--
-- Name: ist_personkontakt; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE ist_personkontakt (
    id integer NOT NULL,
    subjekt_id integer,
    objekt_id integer
);


ALTER TABLE ist_personkontakt OWNER TO mbue;

--
-- Name: ist_raumkontakt; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE ist_raumkontakt (
    id integer NOT NULL,
    subjekt_id integer,
    objekt_id integer
);


ALTER TABLE ist_raumkontakt OWNER TO mbue;

--
-- Name: ist_raumorganisation; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE ist_raumorganisation (
    id integer NOT NULL,
    subjekt_id integer,
    objekt_id integer
);


ALTER TABLE ist_raumorganisation OWNER TO mbue;

--
-- Name: ist_unterorganisation; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE ist_unterorganisation (
    id integer NOT NULL,
    subjekt_id integer,
    objekt_id integer
);


ALTER TABLE ist_unterorganisation OWNER TO mbue;

--
-- Name: pre_ist_relation_view; Type: VIEW; Schema: bund; Owner: mbue
--

CREATE VIEW pre_ist_relation_view AS
 SELECT base.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    ist_mitglied.subjekt_id,
    ist_mitglied.objekt_id
   FROM (base
     JOIN ist_mitglied USING (id))
UNION ALL
 SELECT base.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    ist_autorin.subjekt_id,
    ist_autorin.objekt_id
   FROM (base
     JOIN ist_autorin USING (id))
UNION ALL
 SELECT base.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    ist_personkontakt.subjekt_id,
    ist_personkontakt.objekt_id
   FROM (base
     JOIN ist_personkontakt USING (id))
UNION ALL
 SELECT base.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    ist_organisationkontakt.subjekt_id,
    ist_organisationkontakt.objekt_id
   FROM (base
     JOIN ist_organisationkontakt USING (id))
UNION ALL
 SELECT base.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    ist_unterorganisation.subjekt_id,
    ist_unterorganisation.objekt_id
   FROM (base
     JOIN ist_unterorganisation USING (id))
UNION ALL
 SELECT base.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    ist_raumkontakt.subjekt_id,
    ist_raumkontakt.objekt_id
   FROM (base
     JOIN ist_raumkontakt USING (id))
UNION ALL
 SELECT base.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    ist_raumorganisation.subjekt_id,
    ist_raumorganisation.objekt_id
   FROM (base
     JOIN ist_raumorganisation USING (id))
UNION ALL
 SELECT base.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    ist_aktionaktive.subjekt_id,
    ist_aktionaktive.objekt_id
   FROM (base
     JOIN ist_aktionaktive USING (id))
UNION ALL
 SELECT base.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    ist_aktionsraum.subjekt_id,
    ist_aktionsraum.objekt_id
   FROM (base
     JOIN ist_aktionsraum USING (id))
UNION ALL
 SELECT base.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    rel.subjekt_id,
    rel.objekt_id
   FROM (base
     JOIN ist_thema rel USING (id));


ALTER TABLE pre_ist_relation_view OWNER TO mbue;

--
-- Name: ist_relation_view; Type: VIEW; Schema: bund; Owner: mbue
--

CREATE VIEW ist_relation_view AS
 SELECT rel.id,
    rel.datum,
    rel.discriminator,
    rel.url,
    rel.bemerkungen,
    rel.subjekt_id,
    rel.objekt_id,
    subjekt.friendly AS subjekt_friendly,
    subjekt.discriminator AS subjekt_discriminator,
    objekt.friendly AS objekt_friendly,
    objekt.discriminator AS objekt_discriminator,
    (((((subjekt.friendly)::text || ' ist '::text) || initcap("substring"((rel.discriminator)::text, 5))) || ' von '::text) || (objekt.friendly)::text) AS friendly
   FROM ((pre_ist_relation_view rel
     JOIN base_view subjekt ON ((rel.subjekt_id = subjekt.id)))
     JOIN base_view objekt ON ((rel.objekt_id = objekt.id)));


ALTER TABLE ist_relation_view OWNER TO mbue;

--
-- Name: kategorie; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE kategorie (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE kategorie OWNER TO mbue;

--
-- Name: kategorie_id_seq; Type: SEQUENCE; Schema: bund; Owner: mbue
--

CREATE SEQUENCE kategorie_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE kategorie_id_seq OWNER TO mbue;

--
-- Name: kategorie_id_seq; Type: SEQUENCE OWNED BY; Schema: bund; Owner: mbue
--

ALTER SEQUENCE kategorie_id_seq OWNED BY kategorie.id;


--
-- Name: literatur; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE literatur (
    id integer NOT NULL,
    titel character varying(100) NOT NULL,
    untertitel character varying(100),
    verlag character varying(100),
    jahr character varying(10)
);


ALTER TABLE literatur OWNER TO mbue;

--
-- Name: objeignung; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE objeignung (
    obj_id integer NOT NULL,
    eign_id integer NOT NULL
);


ALTER TABLE objeignung OWNER TO mbue;

--
-- Name: organisation_view; Type: VIEW; Schema: bund; Owner: mbue
--

CREATE VIEW organisation_view AS
 SELECT base.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    organisation.name,
    organisation.name AS friendly,
    organisation.name AS sortname
   FROM (base
     JOIN organisation USING (id));


ALTER TABLE organisation_view OWNER TO mbue;

--
-- Name: person_orga_view; Type: VIEW; Schema: bund; Owner: mbue
--

CREATE VIEW person_orga_view AS
 SELECT person.id,
    string_agg((organisation.name)::text, ', '::text) AS orga
   FROM person,
    organisation,
    ist_mitglied
  WHERE ((person.id = ist_mitglied.subjekt_id) AND (ist_mitglied.objekt_id = organisation.id))
  GROUP BY person.id;


ALTER TABLE person_orga_view OWNER TO mbue;

--
-- Name: person_view; Type: VIEW; Schema: bund; Owner: mbue
--

CREATE VIEW person_view AS
 SELECT person.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    person.vorname,
    person.name,
    person_sortname((person.vorname)::text, (person.name)::text) AS sortname,
    person_friendly((person.vorname)::text, (person.name)::text) AS friendly,
    person.titel,
    person.anrede,
    person.funktion,
    person.kontaktaufnahme,
    person_orga_view.orga,
    base_themen_view.themen
   FROM (((base
     JOIN person USING (id))
     LEFT JOIN person_orga_view ON ((base.id = person_orga_view.id)))
     LEFT JOIN base_themen_view ON ((base.id = base_themen_view.id)));


ALTER TABLE person_view OWNER TO mbue;

--
-- Name: projekt_view; Type: VIEW; Schema: bund; Owner: mbue
--

CREATE VIEW projekt_view AS
 SELECT base.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    aktion.name,
    aktion.name AS friendly,
    aktion.name AS sortname
   FROM (base
     JOIN aktion USING (id));


ALTER TABLE projekt_view OWNER TO mbue;

--
-- Name: raum_view; Type: VIEW; Schema: bund; Owner: mbue
--

CREATE VIEW raum_view AS
 SELECT base.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    raum.name,
    raum.groesse_qm,
    raum.personenzahl,
    raum.verwaltung,
    raum.kosten,
    raum.lage,
    raum.name AS friendly,
    raum.name AS sortname
   FROM (base
     JOIN raum USING (id));


ALTER TABLE raum_view OWNER TO mbue;

--
-- Name: referentin; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE referentin (
    id integer NOT NULL,
    honorar character varying(100),
    ansprache character varying(100)
);


ALTER TABLE referentin OWNER TO mbue;

--
-- Name: referentin_view; Type: VIEW; Schema: bund; Owner: mbue
--

CREATE VIEW referentin_view AS
 SELECT person_view.id,
    person_view.datum,
    person_view.discriminator,
    person_view.url,
    person_view.bemerkungen,
    person_view.vorname,
    person_view.name,
    person_view.sortname,
    person_view.friendly,
    person_view.titel,
    person_view.anrede,
    person_view.funktion,
    person_view.kontaktaufnahme,
    person_view.orga,
    person_view.themen,
    referentin.honorar,
    referentin.ansprache
   FROM person_view,
    referentin
  WHERE (person_view.id = referentin.id);


ALTER TABLE referentin_view OWNER TO mbue;

--
-- Name: relfoerdungsziel; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE relfoerdungsziel (
    foerderung_id integer NOT NULL,
    f_ziel_id integer NOT NULL
);


ALTER TABLE relfoerdungsziel OWNER TO mbue;

--
-- Name: ressource_autorinnen_view; Type: VIEW; Schema: bund; Owner: mbue
--

CREATE VIEW ressource_autorinnen_view AS
 SELECT ressource.id,
    string_agg(person_friendly((person.vorname)::text, (person.name)::text), ', '::text) AS autorinnen
   FROM ressource,
    person,
    ist_autorin
  WHERE ((person.id = ist_autorin.subjekt_id) AND (ist_autorin.objekt_id = ressource.id))
  GROUP BY ressource.id;


ALTER TABLE ressource_autorinnen_view OWNER TO mbue;

--
-- Name: ressource_view; Type: VIEW; Schema: bund; Owner: mbue
--

CREATE VIEW ressource_view AS
 SELECT ressource.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    ressource.titel,
    ressource.titel AS sortname,
    ressource.titel AS friendly,
    ressource.zielgruppe,
    ressource.erstellungsdatum,
    ressource_autorinnen_view.autorinnen
   FROM ((base
     JOIN ressource USING (id))
     LEFT JOIN ressource_autorinnen_view ON ((base.id = ressource_autorinnen_view.id)));


ALTER TABLE ressource_view OWNER TO mbue;

--
-- Name: ressourceanwendung; Type: TABLE; Schema: bund; Owner: mbue
--

CREATE TABLE ressourceanwendung (
    ressource_id integer NOT NULL,
    anwendung_id integer NOT NULL
);


ALTER TABLE ressourceanwendung OWNER TO mbue;

--
-- Name: test_view; Type: VIEW; Schema: bund; Owner: mbue
--

CREATE VIEW test_view AS
 SELECT base.id AS base_id,
    person.id AS person_id,
    referentin.id AS referentin_id,
    organisation.id AS organisation_id
   FROM (((base
     LEFT JOIN person ON ((base.id = person.id)))
     LEFT JOIN organisation ON ((base.id = organisation.id)))
     LEFT JOIN referentin ON ((base.id = referentin.id)));


ALTER TABLE test_view OWNER TO mbue;

--
-- Name: thema_id_seq; Type: SEQUENCE; Schema: bund; Owner: mbue
--

CREATE SEQUENCE thema_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE thema_id_seq OWNER TO mbue;

--
-- Name: thema_id_seq; Type: SEQUENCE OWNED BY; Schema: bund; Owner: mbue
--

ALTER SEQUENCE thema_id_seq OWNED BY thema.id;


--
-- Name: thema_view; Type: VIEW; Schema: bund; Owner: mbue
--

CREATE VIEW thema_view AS
 SELECT base.id,
    base.datum,
    base.discriminator,
    base.url,
    base.bemerkungen,
    thema.thema,
    thema.suchhilfe,
    thema.thema AS friendly
   FROM (base
     JOIN thema USING (id));


ALTER TABLE thema_view OWNER TO mbue;

--
-- Name: adresse id; Type: DEFAULT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY adresse ALTER COLUMN id SET DEFAULT nextval('adresse_id_seq'::regclass);


--
-- Name: anwendungsbereich id; Type: DEFAULT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY anwendungsbereich ALTER COLUMN id SET DEFAULT nextval('anwendungsbereich_id_seq'::regclass);


--
-- Name: eignung id; Type: DEFAULT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY eignung ALTER COLUMN id SET DEFAULT nextval('eignung_id_seq'::regclass);


--
-- Name: f_ziel id; Type: DEFAULT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY f_ziel ALTER COLUMN id SET DEFAULT nextval('f_ziel_id_seq'::regclass);


--
-- Name: historie id; Type: DEFAULT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY historie ALTER COLUMN id SET DEFAULT nextval('historie_id_seq'::regclass);


--
-- Name: kategorie id; Type: DEFAULT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY kategorie ALTER COLUMN id SET DEFAULT nextval('kategorie_id_seq'::regclass);


--
-- Name: adresse adresse_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY adresse
    ADD CONSTRAINT adresse_pkey PRIMARY KEY (id);


--
-- Name: anwendungsbereich anwendungsbereich_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY anwendungsbereich
    ADD CONSTRAINT anwendungsbereich_pkey PRIMARY KEY (id);


--
-- Name: base base_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY base
    ADD CONSTRAINT base_pkey PRIMARY KEY (id);


--
-- Name: eignung eignung_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY eignung
    ADD CONSTRAINT eignung_pkey PRIMARY KEY (id);


--
-- Name: f_ziel f_ziel_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY f_ziel
    ADD CONSTRAINT f_ziel_pkey PRIMARY KEY (id);


--
-- Name: film film_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY film
    ADD CONSTRAINT film_pkey PRIMARY KEY (id);


--
-- Name: foerderung foerderung_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY foerderung
    ADD CONSTRAINT foerderung_pkey PRIMARY KEY (id);


--
-- Name: historie historie_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY historie
    ADD CONSTRAINT historie_pkey PRIMARY KEY (id);


--
-- Name: inventar inventar_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY inventar
    ADD CONSTRAINT inventar_pkey PRIMARY KEY (id);


--
-- Name: inventarkategorie inventarkategorie_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY inventarkategorie
    ADD CONSTRAINT inventarkategorie_pkey PRIMARY KEY (inventar_id, kategorie_id);


--
-- Name: ist_aktionsraum ist_aktionsraum_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_aktionsraum
    ADD CONSTRAINT ist_aktionsraum_pkey PRIMARY KEY (id);


--
-- Name: ist_aktionsraum ist_aktionsraum_subjekt_id_objekt_id_key; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_aktionsraum
    ADD CONSTRAINT ist_aktionsraum_subjekt_id_objekt_id_key UNIQUE (subjekt_id, objekt_id);


--
-- Name: ist_autorin ist_autorin_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_autorin
    ADD CONSTRAINT ist_autorin_pkey PRIMARY KEY (id);


--
-- Name: ist_autorin ist_autorin_subjekt_id_objekt_id_key; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_autorin
    ADD CONSTRAINT ist_autorin_subjekt_id_objekt_id_key UNIQUE (subjekt_id, objekt_id);


--
-- Name: ist_mitglied ist_mitglied_subjekt_id_objekt_id_key; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_mitglied
    ADD CONSTRAINT ist_mitglied_subjekt_id_objekt_id_key UNIQUE (subjekt_id, objekt_id);


--
-- Name: ist_organisationkontakt ist_organisationkontakt_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_organisationkontakt
    ADD CONSTRAINT ist_organisationkontakt_pkey PRIMARY KEY (id);


--
-- Name: ist_organisationkontakt ist_organisationkontakt_subjekt_id_objekt_id_key; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_organisationkontakt
    ADD CONSTRAINT ist_organisationkontakt_subjekt_id_objekt_id_key UNIQUE (subjekt_id, objekt_id);


--
-- Name: ist_personkontakt ist_personkontakt_subjekt_id_objekt_id_key; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_personkontakt
    ADD CONSTRAINT ist_personkontakt_subjekt_id_objekt_id_key UNIQUE (objekt_id, subjekt_id);


--
-- Name: ist_aktionaktive ist_projektaktive_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_aktionaktive
    ADD CONSTRAINT ist_projektaktive_pkey PRIMARY KEY (id);


--
-- Name: ist_aktionaktive ist_projektaktive_subjekt_id_objekt_id_key; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_aktionaktive
    ADD CONSTRAINT ist_projektaktive_subjekt_id_objekt_id_key UNIQUE (subjekt_id, objekt_id);


--
-- Name: ist_raumkontakt ist_raumkontakt_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_raumkontakt
    ADD CONSTRAINT ist_raumkontakt_pkey PRIMARY KEY (id);


--
-- Name: ist_raumkontakt ist_raumkontakt_subjekt_id_objekt_id_key; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_raumkontakt
    ADD CONSTRAINT ist_raumkontakt_subjekt_id_objekt_id_key UNIQUE (subjekt_id, objekt_id);


--
-- Name: ist_raumorganisation ist_raumorganisation_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_raumorganisation
    ADD CONSTRAINT ist_raumorganisation_pkey PRIMARY KEY (id);


--
-- Name: ist_raumorganisation ist_raumorganisation_subjekt_id_objekt_id_key; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_raumorganisation
    ADD CONSTRAINT ist_raumorganisation_subjekt_id_objekt_id_key UNIQUE (subjekt_id, objekt_id);


--
-- Name: ist_thema ist_thema_subjekt_id_objekt_id_key; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_thema
    ADD CONSTRAINT ist_thema_subjekt_id_objekt_id_key UNIQUE (subjekt_id, objekt_id);


--
-- Name: ist_unterorganisation ist_unterorganisation_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_unterorganisation
    ADD CONSTRAINT ist_unterorganisation_pkey PRIMARY KEY (id);


--
-- Name: ist_unterorganisation ist_unterorganisation_subjekt_id_objekt_id_key; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_unterorganisation
    ADD CONSTRAINT ist_unterorganisation_subjekt_id_objekt_id_key UNIQUE (subjekt_id, objekt_id);


--
-- Name: kategorie kategorie_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY kategorie
    ADD CONSTRAINT kategorie_pkey PRIMARY KEY (id);


--
-- Name: literatur literatur_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY literatur
    ADD CONSTRAINT literatur_pkey PRIMARY KEY (id);


--
-- Name: ist_mitglied mitgliedschaft_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_mitglied
    ADD CONSTRAINT mitgliedschaft_pkey PRIMARY KEY (id);


--
-- Name: objeignung objeignung_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY objeignung
    ADD CONSTRAINT objeignung_pkey PRIMARY KEY (obj_id, eign_id);


--
-- Name: organisation organisation_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY organisation
    ADD CONSTRAINT organisation_pkey PRIMARY KEY (id);


--
-- Name: person person_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);


--
-- Name: ist_personkontakt personkontakt_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_personkontakt
    ADD CONSTRAINT personkontakt_pkey PRIMARY KEY (id);


--
-- Name: aktion projekt_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY aktion
    ADD CONSTRAINT projekt_pkey PRIMARY KEY (id);


--
-- Name: raum raum_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY raum
    ADD CONSTRAINT raum_pkey PRIMARY KEY (id);


--
-- Name: referentin referentin_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY referentin
    ADD CONSTRAINT referentin_pkey PRIMARY KEY (id);


--
-- Name: relfoerdungsziel relfoerdungsziel_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY relfoerdungsziel
    ADD CONSTRAINT relfoerdungsziel_pkey PRIMARY KEY (foerderung_id, f_ziel_id);


--
-- Name: ressource ressource_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ressource
    ADD CONSTRAINT ressource_pkey PRIMARY KEY (id);


--
-- Name: ressourceanwendung ressourceanwendung_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ressourceanwendung
    ADD CONSTRAINT ressourceanwendung_pkey PRIMARY KEY (ressource_id, anwendung_id);


--
-- Name: thema thema_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY thema
    ADD CONSTRAINT thema_pkey PRIMARY KEY (id);


--
-- Name: ist_thema themen_pkey; Type: CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_thema
    ADD CONSTRAINT themen_pkey PRIMARY KEY (id);


--
-- Name: adresse adresse_base_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY adresse
    ADD CONSTRAINT adresse_base_id_fkey FOREIGN KEY (base_id) REFERENCES base(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: film film_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY film
    ADD CONSTRAINT film_id_fkey FOREIGN KEY (id) REFERENCES base(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: foerderung foerderung_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY foerderung
    ADD CONSTRAINT foerderung_id_fkey FOREIGN KEY (id) REFERENCES base(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: historie historie_base_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY historie
    ADD CONSTRAINT historie_base_id_fkey FOREIGN KEY (base_id) REFERENCES base(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inventar inventar_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY inventar
    ADD CONSTRAINT inventar_id_fkey FOREIGN KEY (id) REFERENCES base(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inventarkategorie inventarkategorie_inventar_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY inventarkategorie
    ADD CONSTRAINT inventarkategorie_inventar_id_fkey FOREIGN KEY (inventar_id) REFERENCES inventar(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inventarkategorie inventarkategorie_kategorie_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY inventarkategorie
    ADD CONSTRAINT inventarkategorie_kategorie_id_fkey FOREIGN KEY (kategorie_id) REFERENCES kategorie(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_aktionsraum ist_aktionsraum_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_aktionsraum
    ADD CONSTRAINT ist_aktionsraum_id_fkey FOREIGN KEY (id) REFERENCES base(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_aktionsraum ist_aktionsraum_objekt_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_aktionsraum
    ADD CONSTRAINT ist_aktionsraum_objekt_id_fkey FOREIGN KEY (objekt_id) REFERENCES aktion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_aktionsraum ist_aktionsraum_subjekt_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_aktionsraum
    ADD CONSTRAINT ist_aktionsraum_subjekt_id_fkey FOREIGN KEY (subjekt_id) REFERENCES raum(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_autorin ist_autorin_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_autorin
    ADD CONSTRAINT ist_autorin_id_fkey FOREIGN KEY (id) REFERENCES base(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_autorin ist_autorin_objekt_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_autorin
    ADD CONSTRAINT ist_autorin_objekt_id_fkey FOREIGN KEY (objekt_id) REFERENCES ressource(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_autorin ist_autorin_subjekt_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_autorin
    ADD CONSTRAINT ist_autorin_subjekt_id_fkey FOREIGN KEY (subjekt_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_organisationkontakt ist_organisationkontakt_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_organisationkontakt
    ADD CONSTRAINT ist_organisationkontakt_id_fkey FOREIGN KEY (id) REFERENCES base(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_organisationkontakt ist_organisationkontakt_objekt_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_organisationkontakt
    ADD CONSTRAINT ist_organisationkontakt_objekt_id_fkey FOREIGN KEY (objekt_id) REFERENCES organisation(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_organisationkontakt ist_organisationkontakt_subjekt_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_organisationkontakt
    ADD CONSTRAINT ist_organisationkontakt_subjekt_id_fkey FOREIGN KEY (subjekt_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_aktionaktive ist_projektaktive_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_aktionaktive
    ADD CONSTRAINT ist_projektaktive_id_fkey FOREIGN KEY (id) REFERENCES base(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_aktionaktive ist_projektaktive_objekt_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_aktionaktive
    ADD CONSTRAINT ist_projektaktive_objekt_id_fkey FOREIGN KEY (objekt_id) REFERENCES aktion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_aktionaktive ist_projektaktive_subjekt_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_aktionaktive
    ADD CONSTRAINT ist_projektaktive_subjekt_id_fkey FOREIGN KEY (subjekt_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_raumkontakt ist_raumkontakt_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_raumkontakt
    ADD CONSTRAINT ist_raumkontakt_id_fkey FOREIGN KEY (id) REFERENCES base(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_raumkontakt ist_raumkontakt_objekt_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_raumkontakt
    ADD CONSTRAINT ist_raumkontakt_objekt_id_fkey FOREIGN KEY (objekt_id) REFERENCES raum(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_raumkontakt ist_raumkontakt_subjekt_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_raumkontakt
    ADD CONSTRAINT ist_raumkontakt_subjekt_id_fkey FOREIGN KEY (subjekt_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_raumorganisation ist_raumorganisation_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_raumorganisation
    ADD CONSTRAINT ist_raumorganisation_id_fkey FOREIGN KEY (id) REFERENCES base(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_raumorganisation ist_raumorganisation_objekt_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_raumorganisation
    ADD CONSTRAINT ist_raumorganisation_objekt_id_fkey FOREIGN KEY (objekt_id) REFERENCES raum(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_raumorganisation ist_raumorganisation_subjekt_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_raumorganisation
    ADD CONSTRAINT ist_raumorganisation_subjekt_id_fkey FOREIGN KEY (subjekt_id) REFERENCES organisation(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_thema ist_thema_objekt_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_thema
    ADD CONSTRAINT ist_thema_objekt_id_fkey FOREIGN KEY (objekt_id) REFERENCES base(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_thema ist_thema_subjekt_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_thema
    ADD CONSTRAINT ist_thema_subjekt_id_fkey FOREIGN KEY (subjekt_id) REFERENCES thema(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_unterorganisation ist_unterorganisation_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_unterorganisation
    ADD CONSTRAINT ist_unterorganisation_id_fkey FOREIGN KEY (id) REFERENCES base(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_unterorganisation ist_unterorganisation_objekt_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_unterorganisation
    ADD CONSTRAINT ist_unterorganisation_objekt_id_fkey FOREIGN KEY (objekt_id) REFERENCES organisation(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_unterorganisation ist_unterorganisation_subjekt_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_unterorganisation
    ADD CONSTRAINT ist_unterorganisation_subjekt_id_fkey FOREIGN KEY (subjekt_id) REFERENCES organisation(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: literatur literatur_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY literatur
    ADD CONSTRAINT literatur_id_fkey FOREIGN KEY (id) REFERENCES base(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_mitglied mitgliedschaft_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_mitglied
    ADD CONSTRAINT mitgliedschaft_id_fkey FOREIGN KEY (id) REFERENCES base(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_mitglied mitgliedschaft_organisation_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_mitglied
    ADD CONSTRAINT mitgliedschaft_organisation_id_fkey FOREIGN KEY (objekt_id) REFERENCES organisation(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_mitglied mitgliedschaft_person_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_mitglied
    ADD CONSTRAINT mitgliedschaft_person_id_fkey FOREIGN KEY (subjekt_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: objeignung objeignung_eign_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY objeignung
    ADD CONSTRAINT objeignung_eign_id_fkey FOREIGN KEY (eign_id) REFERENCES eignung(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: organisation organisation_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY organisation
    ADD CONSTRAINT organisation_id_fkey FOREIGN KEY (id) REFERENCES base(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: person person_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_id_fkey FOREIGN KEY (id) REFERENCES base(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_personkontakt personkontakt_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_personkontakt
    ADD CONSTRAINT personkontakt_id_fkey FOREIGN KEY (id) REFERENCES base(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_personkontakt personkontakt_kontakt_person_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_personkontakt
    ADD CONSTRAINT personkontakt_kontakt_person_id_fkey FOREIGN KEY (objekt_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_personkontakt personkontakt_ziel_person_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_personkontakt
    ADD CONSTRAINT personkontakt_ziel_person_id_fkey FOREIGN KEY (subjekt_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: aktion projekt_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY aktion
    ADD CONSTRAINT projekt_id_fkey FOREIGN KEY (id) REFERENCES base(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: raum raum_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY raum
    ADD CONSTRAINT raum_id_fkey FOREIGN KEY (id) REFERENCES base(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: referentin referentin_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY referentin
    ADD CONSTRAINT referentin_id_fkey FOREIGN KEY (id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: relfoerdungsziel relfoerdungsziel_f_ziel_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY relfoerdungsziel
    ADD CONSTRAINT relfoerdungsziel_f_ziel_id_fkey FOREIGN KEY (f_ziel_id) REFERENCES f_ziel(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: relfoerdungsziel relfoerdungsziel_foerderung_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY relfoerdungsziel
    ADD CONSTRAINT relfoerdungsziel_foerderung_id_fkey FOREIGN KEY (foerderung_id) REFERENCES foerderung(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ressource ressource_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ressource
    ADD CONSTRAINT ressource_id_fkey FOREIGN KEY (id) REFERENCES base(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ressourceanwendung ressourceanwendung_anwendung_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ressourceanwendung
    ADD CONSTRAINT ressourceanwendung_anwendung_id_fkey FOREIGN KEY (anwendung_id) REFERENCES anwendungsbereich(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: thema thema_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY thema
    ADD CONSTRAINT thema_id_fkey FOREIGN KEY (id) REFERENCES base(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ist_thema themen_id_fkey; Type: FK CONSTRAINT; Schema: bund; Owner: mbue
--

ALTER TABLE ONLY ist_thema
    ADD CONSTRAINT themen_id_fkey FOREIGN KEY (id) REFERENCES base(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: bund; Type: ACL; Schema: -; Owner: mbue
--

GRANT USAGE ON SCHEMA bund TO web_auth;
GRANT USAGE ON SCHEMA bund TO web_anon;
GRANT USAGE ON SCHEMA bund TO web_user;


--
-- Name: adresse; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE adresse TO web_user;


--
-- Name: adresse_id_seq; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON SEQUENCE adresse_id_seq TO web_user;


--
-- Name: aktion; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE aktion TO web_user;


--
-- Name: identities; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON SEQUENCE identities TO web_user;


--
-- Name: base; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE base TO web_user;


--
-- Name: aktion_view; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE aktion_view TO web_user;


--
-- Name: anwendungsbereich; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE anwendungsbereich TO web_user;


--
-- Name: anwendungsbereich_id_seq; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON SEQUENCE anwendungsbereich_id_seq TO web_user;


--
-- Name: ist_thema; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE ist_thema TO web_user;


--
-- Name: thema; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE thema TO web_user;


--
-- Name: base_themen_view; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE base_themen_view TO web_user;


--
-- Name: inventar; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE inventar TO web_user;


--
-- Name: organisation; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE organisation TO web_user;


--
-- Name: person; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE person TO web_user;


--
-- Name: raum; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE raum TO web_user;


--
-- Name: ressource; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE ressource TO web_user;


--
-- Name: base_view; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE base_view TO web_user;


--
-- Name: eignung; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE eignung TO web_user;


--
-- Name: eignung_id_seq; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON SEQUENCE eignung_id_seq TO web_user;


--
-- Name: f_ziel; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE f_ziel TO web_user;


--
-- Name: f_ziel_id_seq; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON SEQUENCE f_ziel_id_seq TO web_user;


--
-- Name: film; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE film TO web_user;


--
-- Name: foerderung; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE foerderung TO web_user;


--
-- Name: historie; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE historie TO web_user;


--
-- Name: historie_id_seq; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON SEQUENCE historie_id_seq TO web_user;


--
-- Name: inventar_view; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE inventar_view TO web_user;


--
-- Name: inventarkategorie; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE inventarkategorie TO web_user;


--
-- Name: ist_aktionaktive; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE ist_aktionaktive TO web_user;


--
-- Name: ist_aktionsraum; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE ist_aktionsraum TO web_user;


--
-- Name: ist_autorin; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE ist_autorin TO web_user;


--
-- Name: ist_mitglied; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE ist_mitglied TO web_user;


--
-- Name: ist_organisationkontakt; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE ist_organisationkontakt TO web_user;


--
-- Name: ist_personkontakt; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE ist_personkontakt TO web_user;


--
-- Name: ist_raumkontakt; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE ist_raumkontakt TO web_user;


--
-- Name: ist_raumorganisation; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE ist_raumorganisation TO web_user;


--
-- Name: ist_unterorganisation; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE ist_unterorganisation TO web_user;


--
-- Name: pre_ist_relation_view; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE pre_ist_relation_view TO web_user;


--
-- Name: ist_relation_view; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE ist_relation_view TO web_user;


--
-- Name: kategorie; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE kategorie TO web_user;


--
-- Name: kategorie_id_seq; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON SEQUENCE kategorie_id_seq TO web_user;


--
-- Name: literatur; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE literatur TO web_user;


--
-- Name: objeignung; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE objeignung TO web_user;


--
-- Name: organisation_view; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE organisation_view TO web_user;


--
-- Name: person_orga_view; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE person_orga_view TO web_user;


--
-- Name: person_view; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE person_view TO web_user;


--
-- Name: projekt_view; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE projekt_view TO web_user;


--
-- Name: raum_view; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE raum_view TO web_user;


--
-- Name: referentin; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE referentin TO web_user;


--
-- Name: referentin_view; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE referentin_view TO web_user;


--
-- Name: relfoerdungsziel; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE relfoerdungsziel TO web_user;


--
-- Name: ressource_autorinnen_view; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE ressource_autorinnen_view TO web_user;


--
-- Name: ressource_view; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE ressource_view TO web_user;


--
-- Name: ressourceanwendung; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE ressourceanwendung TO web_user;


--
-- Name: test_view; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE test_view TO web_user;


--
-- Name: thema_id_seq; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON SEQUENCE thema_id_seq TO web_user;


--
-- Name: thema_view; Type: ACL; Schema: bund; Owner: mbue
--

GRANT ALL ON TABLE thema_view TO web_user;


--
-- PostgreSQL database dump complete
--

