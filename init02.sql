set search_path to bund, public;
set role mbue;

-- Aktionspartnerorga
create table ist_aktionspartnerorga (
    id integer primary key references base (id) on delete cascade on update cascade,
    subjekt_id integer references organisation (id) on delete cascade on update cascade,
    objekt_id integer references aktion (id) on delete cascade on update cascade,
    unique (subjekt_id, objekt_id)
);

CREATE FUNCTION insert_ist_aktionspartnerorga(subjekt_id integer, objekt_id integer, out id integer) AS $$
    WITH ins1 AS (
        INSERT INTO base (discriminator) VALUES ('ist_aktionspartnerorga') RETURNING id AS base_id
    )
    INSERT INTO ist_aktionspartnerorga (id, subjekt_id, objekt_id) SELECT base_id, $1, $2 FROM ins1 RETURNING id;
$$ LANGUAGE SQL;

create or replace view pre_ist_relation_view as
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
(select * from base natural join ist_aktionsinventar)
union all
(select * from base natural join ist_aktionspartnerorga)
union all
(select * from base natural join ist_thema rel);

-- Constraints vergessen!
alter table person alter column name set not null;
alter table organisation alter column name set not null;

-- letztes Mal vergessen...
grant all on all tables in schema bund to web_user;
grant all on all sequences in schema bund to web_user;
