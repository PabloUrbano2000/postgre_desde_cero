-- CONSTRAINTS

-- agregar primary key en la tabla country
alter table country
	add primary key (code);
	
-- delete from country where  code = 'NLD' and code2 = 'NA';

-- agregar check en la columna surfacearea de la tabla country
alter table country add constraint CK_COUNTRY_SURFACEAREA CHECK(
	surfacearea >= 0
);

-- agregar check en la columna continent de la tabla country
alter table country add constraint CK_COUNTRY_CONTINENT CHECK(
	continent in 	('Asia', 'South America',
					'North America', 'Oceania',
					'Antarctica', 'Africa', 'Europe','Central America')
	);


-- eliminar un constraint
alter table country drop constraint  country_continent_check;
 
 -- obtener todos los constraints de un schema y una tabla
SELECT con.*
       FROM pg_catalog.pg_constraint con
            INNER JOIN pg_catalog.pg_class rel
                       ON rel.oid = con.conrelid
            INNER JOIN pg_catalog.pg_namespace nsp
                       ON nsp.oid = connamespace
       WHERE nsp.nspname = 'public'
             AND rel.relname = 'country';
             
 
 
-- crear index en name
-- con unique las la columna de una fila no pueden repetirse en otras filas
create unique index unique_country_name on country (
	name
);

-- sin el unique permite duplicados (recomendado)
create index country_continent on country (
	continent
);

-- obtener todos los indices
select schemaname, tablename, indexname from pg_indexes;

