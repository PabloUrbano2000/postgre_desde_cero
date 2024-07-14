select distinct continent from country order by continent;

insert into continent (name) select distinct continent from country order by continent;

-- This script only contains the table creation statements and does not fully represent the table in the database. Do not use it as a backup.


-- SCRIPT PARA REALIZAR UNA ACTUALIZACIÓN MASIVA ¡IMPORTANTE SIEMPRE REALIZAR UN BACKUP!

-- Table Definition
CREATE TABLE "public"."country_bk" (
    "code" bpchar(3) NOT NULL,
    "name" text NOT NULL,
    "continent" text NOT NULL,
    "region" text NOT NULL,
    "surfacearea" float4 NOT NULL,
    "indepyear" int2,
    "population" int4 NOT NULL,
    "lifeexpectancy" float4,
    "gnp" numeric(10,2),
    "gnpold" numeric(10,2),
    "localname" text NOT NULL,
    "governmentform" text NOT NULL,
    "headofstate" text,
    "capital" int4,
    "code2" bpchar(2) NOT NULL,
    PRIMARY KEY ("code")
);

-- drop table public.country_bk;

-- insert into country_bk select * from country;

-- verificamos el constraint
SELECT con.*
       FROM pg_catalog.pg_constraint con
            INNER JOIN pg_catalog.pg_class rel
                       ON rel.oid = con.conrelid
            INNER JOIN pg_catalog.pg_namespace nsp
                       ON nsp.oid = connamespace
       WHERE nsp.nspname = 'public'
             AND rel.relname = 'country';
     
-- eliminamos el constraint
alter table country drop constraint ck_country_continent;

-- verificamos el dato que queremos obtener
select
	a.name, a.continent, 
	(select "code" from continent b where b."name" = a.continent)
from country a;

-- actualizamos de forma másiva
update country a
set continent = (select "code" from continent b where b."name" = a.continent);


-- actualizar el tipo de la columna recientemente actualizada
alter table country alter COLUMN continent type int4
using continent::integer;

-- using cast(continent as integer)::integer;
-- using continent/1;

-- nos aseguramos que la tabla recientemente creada continent tenga valores únicos
ALTER TABLE continent ADD CONSTRAINT unique_continent_code UNIQUE (code);

select schemaname, tablename, indexname from pg_indexes
where tablename= 'country';

-- agregando foreign key
alter table country add constraint fk_country_continent_code
foreign key(continent) references continent(code);
