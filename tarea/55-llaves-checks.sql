-- 1. Crear una llave primaria en city (id)
alter table city add constraint PK_CITY_ID primary key (id);


-- 2. Crear un check en population, para que no soporte negativos
alter table city add constraint CK_CITY_POPULATION check (population >= 0);

-- 3. Crear una llave primaria compuesta en "countrylanguage"
-- los campos a usar como llave compuesta son countrycode y language
alter table countrylanguage add constraint PK_COUNTRYLANGUAGE primary key (countrycode, language);

-- 4. Crear check en percentage, 
-- Para que no permita negativos ni números superiores a 100
alter table countrylanguage add constraint CK_COUNTRYLANGUAGE_PERCENTAGE
check (percentage between 0 and 100);


-- 1. Crear una llave primaria en city (id)
alter table city add constraint PK_CITY_ID primary key (id);


-- 2. Crear un check en population, para que no soporte negativos
alter table city add constraint CK_CITY_POPULATION check (population >= 0);

-- 3. Crear una llave primaria compuesta en "countrylanguage"
-- los campos a usar como llave compuesta son countrycode y language
alter table countrylanguage add constraint PK_COUNTRYLANGUAGE primary key (countrycode, language);

-- 4. Crear check en percentage, 
-- Para que no permita negativos ni números superiores a 100
alter table countrylanguage add constraint CK_COUNTRYLANGUAGE_PERCENTAGE
check (percentage between 0 and 100);

-- agregando foreign key
alter table city
	add constraint FK_CITY_COUNTRY_ID
	foreign key (countrycode) references country (code); -- on delete cascade



INSERT INTO country
	values('AFG', 'Afghanistan', 'Asia', 'Southern Asia', 652860, 1919, 40000000, 62, 69000000, NULL, 'Afghanistan', 'Totalitarian', NULL, NULL, 'AF');
	
	
alter table countrylanguage
	add constraint FK_COUNTRYLANGUAGE_COUNTRY_ID
	foreign key (countrycode) references country (code); -- on delete cascade
