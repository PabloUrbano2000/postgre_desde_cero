

-- Tarea con countryLanguage

-- Crear la tabla de language

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS language_code_seq;


-- Table Definition
CREATE TABLE "public"."language" (
    "code" int4 NOT NULL DEFAULT 	nextval('language_code_seq'::regclass),
    "name" text NOT NULL,
    PRIMARY KEY ("code")
);

-- Crear una columna en countrylanguage
ALTER TABLE countrylanguage
ADD COLUMN languagecode varchar(3);

-- insercción de datos
insert into public.language (name) select distinct
"language"
from countrylanguage;

select * from public.language;

-- Empezar con el select para confirmar lo que vamos a actualizar
select distinct
cl."language"
from countrylanguage cl order by cl."language";

select
cl."language", (select code from LANGUAGE l where l.name = cl."language")
from countrylanguage cl;

-- Actualizar todos los registros
update countrylanguage cl
set languagecode = (select l.code from LANGUAGE l where l.name = cl."language");

select * from countrylanguage;

-- Cambiar tipo de dato en countrylanguage - languagecode por int4
alter table countrylanguage
alter COLUMN languagecode type int4
USING languagecode::integer;

-- Crear el forening key y constraints de no nulo el language_code
alter table countrylanguage
add CONSTRAINT FK_languagecode_language_code
FOREIGN key(languagecode) REFERENCES "language"(code);

alter table countrylanguage
alter column languagecode set not null;

-- Revisar lo creado
select * from countrylanguage;