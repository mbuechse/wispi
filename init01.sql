set search_path to bund, public;
set role mbue;

-- Thema BUNDjugend umbenennen in Kinder und Jugend
update thema set thema = 'Kinder und Jugend' where id = 86;
-- Thema Insekten löschen
delete from base where id = 83;

-- Eintrag LAK löschen
delete from base where id = 203;

-- Aktionsinventar
create table ist_aktionsinventar (
    id integer primary key references base (id) on delete cascade on update cascade,
    subjekt_id integer references inventar (id) on delete cascade on update cascade,
    objekt_id integer references aktion (id) on delete cascade on update cascade,
    unique (subjekt_id, objekt_id)
);

CREATE FUNCTION insert_ist_aktionsinventar(subjekt_id integer, objekt_id integer, out id integer) AS $$
    WITH ins1 AS (
        INSERT INTO base (discriminator) VALUES ('ist_aktionsinventar') RETURNING id AS base_id
    )
    INSERT INTO ist_aktionsinventar (id, subjekt_id, objekt_id) SELECT base_id, $1, $2 FROM ins1 RETURNING id;
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
(select * from base natural join ist_thema rel);


-- Ansprache in die Person übernehmen
alter table person add column ansprache varchar(100);
update person set ansprache = r.ansprache from referentin r where person.id = r.id;

create or replace view person_view as
select person.id id, datum, discriminator, url, bemerkungen, vorname, name, person_sortname(vorname, name) sortname, person_friendly(vorname, name) friendly, titel, anrede, funktion, kontaktaufnahme, orga, themen, ansprache from base natural join person left join person_orga_view on base.id = person_orga_view.id left join base_themen_view on base.id = base_themen_view.id;

alter table referentin drop column ansprache cascade;

create view referentin_view as
select person_view.id, datum, discriminator, url, bemerkungen, vorname, name, sortname, friendly, titel, anrede, funktion, kontaktaufnahme, orga, themen, ansprache, honorar from person_view, referentin where
person_view.id = referentin.id;

