-- needs postgres super user!
set role postgres;
create extension if not exists pgcrypto;
ALTER DATABASE bund_db SET "app.jwt_secret" TO 'EcxFeeSrVtMulOEOMy5wnRzYVHOQvXCi';
ALTER DATABASE bund_db SET "app.jwt_expires" TO 10800;  -- drei Stunden
create role web_auth login noinherit password 'BUND';
create role web_anon nologin;
create role web_user nologin;

grant usage on schema basic_auth to web_anon;
grant select on basic_auth.users to web_anon;
grant usage on schema bund to web_anon;
grant execute on function bund.login(text, text) to web_anon;

grant usage on schema bund to web_user;
grant all on all tables in schema bund to web_user;
grant all on all sequences in schema bund to web_user;


grant web_anon to web_auth;
grant web_user to web_auth;
grant mbue to web_auth;

-- pgjwt copy

CREATE OR REPLACE FUNCTION url_encode(data bytea) RETURNS text LANGUAGE sql AS $$
    SELECT translate(encode(data, 'base64'), E'+/=\n', '-_');
$$;


CREATE OR REPLACE FUNCTION url_decode(data text) RETURNS bytea LANGUAGE sql AS $$
WITH t AS (SELECT translate(data, '-_', '+/') AS trans),
     rem AS (SELECT length(t.trans) % 4 AS remainder FROM t) -- compute padding size
    SELECT decode(
        t.trans ||
        CASE WHEN rem.remainder > 0
           THEN repeat('=', (4 - rem.remainder))
           ELSE '' END,
    'base64') FROM t, rem;
$$;


CREATE OR REPLACE FUNCTION algorithm_sign(signables text, secret text, algorithm text)
RETURNS text LANGUAGE sql AS $$
WITH
  alg AS (
    SELECT CASE
      WHEN algorithm = 'HS256' THEN 'sha256'
      WHEN algorithm = 'HS384' THEN 'sha384'
      WHEN algorithm = 'HS512' THEN 'sha512'
      ELSE '' END AS id)  -- hmac throws error
SELECT url_encode(hmac(signables, secret, alg.id)) FROM alg;
$$;


CREATE OR REPLACE FUNCTION sign(payload json, secret text, algorithm text DEFAULT 'HS256')
RETURNS text LANGUAGE sql AS $$
WITH
  header AS (
    SELECT url_encode(convert_to('{"alg":"' || algorithm || '","typ":"JWT"}', 'utf8')) AS data
    ),
  payload AS (
    SELECT url_encode(convert_to(payload::text, 'utf8')) AS data
    ),
  signables AS (
    SELECT header.data || '.' || payload.data AS data FROM header, payload
    )
SELECT
    signables.data || '.' ||
    algorithm_sign(signables.data, secret, algorithm) FROM signables;
$$;


CREATE OR REPLACE FUNCTION verify(token text, secret text, algorithm text DEFAULT 'HS256')
RETURNS table(header json, payload json, valid boolean) LANGUAGE sql AS $$
  SELECT
    convert_from(url_decode(r[1]), 'utf8')::json AS header,
    convert_from(url_decode(r[2]), 'utf8')::json AS payload,
    r[3] = algorithm_sign(r[1] || '.' || r[2], secret, algorithm) AS valid
  FROM regexp_split_to_array(token, '\.') r;
$$;

-- authentication via username/password stolen from PostgREST docs
drop schema basic_auth cascade;

create schema basic_auth;

CREATE TYPE basic_auth.jwt_token AS (
  token text
);

create table basic_auth.users (
  username text primary key,
  pass text not null check (length(pass) < 512),
  role name not null check (length(role) < 512)
);

create function basic_auth.check_role_exists() returns trigger as $$
begin
  if not exists (select 1 from pg_roles as r where r.rolname = new.role) then
    raise foreign_key_violation using message =
      'unknown database role: ' || new.role;
    return null;
  end if;
  return new;
end
$$ language plpgsql;

create constraint trigger ensure_user_role_exists
  after insert or update on basic_auth.users
  for each row
  execute procedure basic_auth.check_role_exists();

create function basic_auth.encrypt_pass() returns trigger as $$
begin
  -- is this correct? new.pass is plain whereas old.pass is encrypted?!
  -- ah okay, maybe if pass isn't affected by an update, we'll receive the old value
  if tg_op = 'INSERT' or new.pass <> old.pass then
    new.pass = crypt(new.pass, gen_salt('bf'));
  end if;
  return new;
end
$$ language plpgsql;

create trigger encrypt_pass
  before insert or update on basic_auth.users
  for each row
  execute procedure basic_auth.encrypt_pass();


create function basic_auth.user_role(email text, pass text) returns name as $$
begin
  set search_path to public;
  return (
  select role from basic_auth.users
   where users.username = user_role.email
     and users.pass = crypt(user_role.pass, users.pass)
  );
end;
$$ language plpgsql;

-- alles neu anlegen
set role mbue;
drop schema bund cascade;

create schema bund;

-- das aktuelle Schema auf bund setzen
set search_path to bund, public;

create sequence identities;

-- discriminator value is equal to the name of the specialization table (organisation, person, mitglied, ...)
-- TODO make trigger that disallows adding another specialization
create table base (
    id integer not null default nextval('identities') primary key,
    datum timestamp with time zone not null default now(),
    discriminator varchar(32) not null,  -- eher informativ: person, organisation, film, etc.
    url varchar(256),
    bemerkungen text
);

create table organisation (
    id integer primary key references base (id) on delete cascade on update cascade,
    name varchar(100)
);

create table person (
    id integer primary key references base (id) on delete cascade on update cascade,
    vorname varchar(100),
    name varchar(100),
    titel varchar(20),
    anrede varchar(20),
    kontaktaufnahme varchar(100),  -- Modus der Kontaktaufahme
    funktion varchar(100)          -- relevante Funktion aus Sicht der RG
);

create table thema (
    id integer primary key references base (id) on delete cascade on update cascade,
    thema varchar(100) not null,
    suchhilfe varchar(400)
);

-- primaer fuer person, organisation, objekt, vielleicht auch anderes?
create table adresse (
    id serial primary key,
    base_id integer references base (id) on delete cascade on update cascade,
    empfaenger varchar(100) not null,
    zeile1 varchar(100),
    zeile2 varchar(100),
    ort varchar(100),
    plz varchar(20),
    tel1 varchar(32),
    tel2 varchar(32),
    email varchar(100),
    art varchar(100),
    kommentar text
);

create table referentin (
    id integer primary key references person (id) on delete cascade on update cascade,
    honorar varchar(100),
    ansprache varchar(100)
);

create table historie (
    id serial primary key,
    base_id integer references base (id) on update cascade on delete cascade,
    datum timestamp with time zone not null default now(),
    username text default current_setting('request.jwt.claim.email'),
    notiz text not null
);

create table ist_thema (
    id integer primary key references base on delete cascade on update cascade,
    subjekt_id integer references thema on delete cascade on update cascade,
    objekt_id integer references base on delete cascade on update cascade,
    unique (subjekt_id, objekt_id)
);

create table ist_mitglied (
    id integer primary key references base (id) on delete cascade on update cascade,
    subjekt_id integer references person (id) on delete cascade on update cascade,
    objekt_id integer references organisation (id) on delete cascade on update cascade,
    unique (subjekt_id, objekt_id)
);

create table ist_personkontakt (
    id integer primary key references base (id) on delete cascade on update cascade,
    subjekt_id integer references person (id) on delete cascade on update cascade,
    objekt_id integer references person (id) on delete cascade on update cascade,
    unique (subjekt_id, objekt_id)
);

create table ist_organisationkontakt (
    id integer primary key references base (id) on delete cascade on update cascade,
    subjekt_id integer references person (id) on delete cascade on update cascade,
    objekt_id integer references organisation (id) on delete cascade on update cascade,
    unique (subjekt_id, objekt_id)
);

create table ist_unterorganisation (
    id integer primary key references base (id) on delete cascade on update cascade,
    subjekt_id integer references organisation (id) on delete cascade on update cascade,
    objekt_id integer references organisation (id) on delete cascade on update cascade,
    unique (subjekt_id, objekt_id)
);

create table eignung (
    id serial primary key,
    eignung varchar(100) not null
);

create table raum (
    id integer primary key references base (id) on delete cascade on update cascade,
    name varchar(100) not null,
    lage varchar(120),
    groesse_qm varchar(10),
    personenzahl integer,
    verwaltung varchar(100),
    kosten varchar(100)
);

create table ist_raumkontakt (
    id integer primary key references base (id) on delete cascade on update cascade,
    subjekt_id integer references person (id) on delete cascade on update cascade,
    objekt_id integer references raum (id) on delete cascade on update cascade,
    unique (subjekt_id, objekt_id)
);

create table ist_raumorganisation (
    id integer primary key references base (id) on delete cascade on update cascade,
    subjekt_id integer references organisation (id) on delete cascade on update cascade,
    objekt_id integer references raum (id) on delete cascade on update cascade,
    unique (subjekt_id, objekt_id)
);

create table aktion (
    id integer primary key references base (id) on delete cascade on update cascade,
    name varchar(100) not null,
    rahmenveranstaltung varchar(100),
    zeitraum varchar(100),
    turnus varchar(100),
    fristen text
);

create table ist_aktionaktive (
    id integer primary key references base (id) on delete cascade on update cascade,
    subjekt_id integer references person (id) on delete cascade on update cascade,
    objekt_id integer references aktion (id) on delete cascade on update cascade,
    unique (subjekt_id, objekt_id)
);

create table ist_aktionsraum (
    id integer primary key references base (id) on delete cascade on update cascade,
    subjekt_id integer references raum (id) on delete cascade on update cascade,
    objekt_id integer references aktion (id) on delete cascade on update cascade,
    unique (subjekt_id, objekt_id)
);

create table objeignung (
    obj_id integer references objekt (id) on delete cascade on update cascade,
    eign_id integer references eignung (id) on delete cascade on update cascade,
    primary key (obj_id, eign_id)
);

create table film (
    id integer primary key references base (id) on delete cascade on update cascade,
    name varchar(100) not null,
    jahr varchar(10),
    einschaetzung varchar(400),
    zielgruppe varchar(100),
    verfuegbarkeit varchar(100)
);

create table literatur (
    id integer primary key references base (id) on delete cascade on update cascade,
    titel varchar(100) not null,
    untertitel varchar(100),
    verlag varchar(100),
    jahr varchar(10)
);

create table f_ziel (
    id serial primary key,
    name varchar(100) not null
);

create table foerderung (
    id integer primary key references base (id) on delete cascade on update cascade,
    name varchar(100) not null,
    fristen varchar(400)
    -- ansprechpersonen varchar(400),
);

create table relfoerdungsziel (
    foerderung_id integer references foerderung (id) on delete cascade on update cascade,
    f_ziel_id integer references f_ziel (id) on delete cascade on update cascade,
    primary key (foerderung_id, f_ziel_id)
);

create table ressource (
    id integer primary key references base (id) on delete cascade on update cascade,
    titel varchar(100) not null,
    zielgruppe varchar(100),
    erstellungsdatum varchar(32)
);

create table ist_autorin (
    id integer primary key references base (id) on delete cascade on update cascade,
    subjekt_id integer references person (id) on delete cascade on update cascade,
    objekt_id integer references ressource (id) on delete cascade on update cascade,
    unique (subjekt_id, objekt_id)
);

-- TODO bislang ungenutzt
create table anwendungsbereich (
    id serial primary key,
    name varchar(100) not null
);

-- TODO bislang ungenutzt
create table ressourceanwendung (
    ressource_id integer references ressource (id) on delete cascade on update cascade,
    anwendung_id integer references anwendungsbereich (id) on delete cascade on update cascade,
    primary key (ressource_id, anwendung_id)
);

create table inventar (
    id integer primary key references base (id) on delete cascade on update cascade,
    bezeichnung varchar(100) not null,
    lagerung varchar(100),
    anschaffung varchar(100),
    zustaendig varchar(100)
);

-- TODO bislang ungenutzt
create table kategorie (
    id serial primary key,
    name varchar(100) not null
);

-- TODO bislang ungenutzt
create table inventarkategorie (
    inventar_id integer references inventar (id) on delete cascade on update cascade,
    kategorie_id integerkategorie_id) references kategorie (id) on delete cascade on update cascade,
    primary key (inventar_id, kategorie_id)
);


-- STORED PROCEDURES

create function login(email text, pass text) returns basic_auth.jwt_token as $$
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
$$ language plpgsql;


CREATE FUNCTION canonicalize(s text) RETURNS text AS $$
    SELECT regexp_replace(replace(replace(replace(replace(lower($1), 'ß', 'ss'), 'ü', 'ue'), 'ö', 'oe'), 'ä', 'ae'), '[^a-zA-Z]', '', 'g');
$$ LANGUAGE SQL;

CREATE FUNCTION person_sortname(vorname text, name text) RETURNS text AS $$
    select case
        when $1 is null
        then $2
        else $2 || ', ' || $1
    end;
$$ LANGUAGE SQL;

CREATE FUNCTION person_friendly(vorname text, name text) RETURNS text AS $$
    select case
        when $1 is null
        then $2
        else $1 || ' ' || $2
    end;
$$ LANGUAGE SQL;

CREATE FUNCTION insert_thema(thema varchar) RETURNS void AS $$
    WITH ins1 AS (
        INSERT INTO base (discriminator) VALUES ('thema') RETURNING id AS base_id
    )
    INSERT INTO thema (id, thema) SELECT base_id, $1 FROM ins1;
$$ LANGUAGE SQL;

CREATE FUNCTION insert_ist_thema(subjekt_id integer, objekt_id integer, out id integer) AS $$
    WITH ins1 AS (
        INSERT INTO base (discriminator) VALUES ('ist_thema') RETURNING id AS base_id
    )
    INSERT INTO ist_thema (id, subjekt_id, objekt_id) SELECT base_id, $1, $2 FROM ins1 RETURNING id;
$$ LANGUAGE SQL;

CREATE FUNCTION insert_ist_mitglied(subjekt_id integer, objekt_id integer, out id integer) AS $$
    WITH ins1 AS (
        INSERT INTO base (discriminator) VALUES ('ist_mitglied') RETURNING id AS base_id
    )
    INSERT INTO ist_mitglied (id, subjekt_id, objekt_id) SELECT base_id, $1, $2 FROM ins1 RETURNING id;
$$ LANGUAGE SQL;

CREATE FUNCTION insert_ist_organisationkontakt(subjekt_id integer, objekt_id integer, out id integer) AS $$
    WITH ins1 AS (
        INSERT INTO base (discriminator) VALUES ('ist_organisationkontakt') RETURNING id AS base_id
    )
    INSERT INTO ist_organisationkontakt (id, subjekt_id, objekt_id) SELECT base_id, $1, $2 FROM ins1 RETURNING id;
$$ LANGUAGE SQL;

CREATE FUNCTION insert_ist_personkontakt(subjekt_id integer, objekt_id integer, out id integer) AS $$
    WITH ins1 AS (
        INSERT INTO base (discriminator) VALUES ('ist_personkontakt') RETURNING id AS base_id
    )
    INSERT INTO ist_personkontakt (id, subjekt_id, objekt_id) SELECT base_id, $1, $2 FROM ins1 RETURNING id;
$$ LANGUAGE SQL;

CREATE FUNCTION insert_ist_unterorganisation(subjekt_id integer, objekt_id integer, out id integer) AS $$
    WITH ins1 AS (
        INSERT INTO base (discriminator) VALUES ('ist_unterorganisation') RETURNING id AS base_id
    )
    INSERT INTO ist_unterorganisation (id, subjekt_id, objekt_id) SELECT base_id, $1, $2 FROM ins1 RETURNING id;
$$ LANGUAGE SQL;

CREATE FUNCTION insert_ist_raumkontakt(subjekt_id integer, objekt_id integer, out id integer) AS $$
    WITH ins1 AS (
        INSERT INTO base (discriminator) VALUES ('ist_raumkontakt') RETURNING id AS base_id
    )
    INSERT INTO ist_raumkontakt (id, subjekt_id, objekt_id) SELECT base_id, $1, $2 FROM ins1 RETURNING id;
$$ LANGUAGE SQL;

CREATE FUNCTION insert_ist_raumorganisation(subjekt_id integer, objekt_id integer, out id integer) AS $$
    WITH ins1 AS (
        INSERT INTO base (discriminator) VALUES ('ist_raumorganisation') RETURNING id AS base_id
    )
    INSERT INTO ist_raumorganisation (id, subjekt_id, objekt_id) SELECT base_id, $1, $2 FROM ins1 RETURNING id;
$$ LANGUAGE SQL;

CREATE FUNCTION insert_ist_aktionaktive(subjekt_id integer, objekt_id integer, out id integer) AS $$
    WITH ins1 AS (
        INSERT INTO base (discriminator) VALUES ('ist_aktionaktive') RETURNING id AS base_id
    )
    INSERT INTO ist_aktionaktive (id, subjekt_id, objekt_id) SELECT base_id, $1, $2 FROM ins1 RETURNING id;
$$ LANGUAGE SQL;

CREATE FUNCTION insert_ist_aktionsraum(subjekt_id integer, objekt_id integer, out id integer) AS $$
    WITH ins1 AS (
        INSERT INTO base (discriminator) VALUES ('ist_aktionsraum') RETURNING id AS base_id
    )
    INSERT INTO ist_aktionsraum (id, subjekt_id, objekt_id) SELECT base_id, $1, $2 FROM ins1 RETURNING id;
$$ LANGUAGE SQL;

CREATE FUNCTION insert_ist_autorin(subjekt_id integer, objekt_id integer, out id integer) AS $$
    WITH ins1 AS (
        INSERT INTO base (discriminator) VALUES ('ist_autorin') RETURNING id AS base_id
    )
    INSERT INTO ist_autorin (id, subjekt_id, objekt_id) SELECT base_id, $1, $2 FROM ins1 RETURNING id;
$$ LANGUAGE SQL;


-- VIEWS

-- muss ausbuchstabiert werden, damit für postgrest die Relation zu base erkenntlich bleibt
create view base_view as
(select base.*, name friendly, canonicalize(name) canonical, name sortname from base natural join organisation)
union all
(select base.*, person_friendly(vorname, name) friendly, (canonicalize(name) || ',' || canonicalize(vorname)) canonical, person_sortname(vorname, name) sortname from base natural join person)
union all
(select base.*, thema friendly, canonicalize(thema) canonical, thema sortname from base natural join thema)
union all
(select base.*, name friendly, canonicalize(name) canonical, name sortname from base natural join aktion)
union all
(select base.*, titel friendly, canonicalize(titel) canonical, titel sortname from base natural join ressource)
union all
(select base.*, bezeichnung friendly, canonicalize(bezeichnung) canonical, bezeichnung sortname from base natural join inventar)
union all
(select base.*, name friendly, canonicalize(name) canonical, name sortname from base natural join raum);

create view organisation_view as
select *, name friendly, name sortname from base natural join organisation;

create view person_orga_view as
select person.id, string_agg(organisation.name, ', ') as orga from person, organisation, ist_mitglied where
person.id = ist_mitglied.subjekt_id and ist_mitglied.objekt_id = organisation.id
group by person.id;

create view ressource_autorinnen_view as
select ressource.id, string_agg(person_friendly(person.vorname, person.name), ', ') as autorinnen from ressource, person, ist_autorin where
person.id = ist_autorin.subjekt_id and ist_autorin.objekt_id = ressource.id
group by ressource.id;

create view raum_view as
select *, name friendly, name sortname from base natural join raum;

create view aktion_view as
select *, name friendly, name sortname from base natural join aktion;

create view inventar_view as
select *, bezeichnung friendly, bezeichnung sortname from base natural join inventar;

create view base_themen_view as
select base.id, string_agg(thema.thema, ', ') as themen from base, thema, ist_thema where
ist_thema.subjekt_id = thema.id and ist_thema.objekt_id = base.id
group by base.id;

create view thema_view as
select *, thema friendly from base natural join thema;

create view person_view as
select person.id id, datum, discriminator, url, bemerkungen, vorname, name, person_sortname(vorname, name) sortname, person_friendly(vorname, name) friendly, titel, anrede, funktion, kontaktaufnahme, orga, themen from base natural join person left join person_orga_view on base.id = person_orga_view.id left join base_themen_view on base.id = base_themen_view.id;

create view referentin_view as
select person_view.id, datum, discriminator, url, bemerkungen, vorname, name, sortname, friendly, titel, anrede, funktion, kontaktaufnahme, orga, themen, honorar, ansprache from person_view, referentin where
person_view.id = referentin.id;

create view ressource_view as
select ressource.id id, datum, discriminator, url, bemerkungen, titel, titel sortname, titel friendly, zielgruppe, erstellungsdatum, autorinnen from base natural join ressource left join ressource_autorinnen_view on base.id = ressource_autorinnen_view.id;

create view pre_ist_relation_view as
(select * from base natural join ist_mitglied)
union all
(select * from base natural join ist_autorin)
union all
(select * from base natural join ist_personkontakt)
union all
(select * from base natural join ist_organisationkontakt)
union all
(select * from base natural join ist_unterorganisation)
union all
(select * from base natural join ist_raumkontakt)
union all
(select * from base natural join ist_raumorganisation)
union all
(select * from base natural join ist_aktionaktive)
union all
(select * from base natural join ist_aktionsraum)
union all
(select * from base natural join ist_thema rel);

create view ist_relation_view as
select rel.*, subjekt.friendly subjekt_friendly, subjekt.discriminator subjekt_discriminator, objekt.friendly objekt_friendly, objekt.discriminator objekt_discriminator, (subjekt.friendly || ' ist ' || initcap(substring(rel.discriminator, 5)) || ' von ' || objekt.friendly) friendly from pre_ist_relation_view rel
join base_view subjekt on subjekt_id = subjekt.id join base_view objekt on objekt_id = objekt.id;
