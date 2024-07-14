-- 1. Ver todos los registros
select * from users;

-- 2. Ver el registro cuyo id sea igual a 10
select * from users where id = 10;

-- 3. Quiero todos los registros que cuyo primer nombre sea Jim (engañosa)
select * from users where name like 'Jim %';

-- 4. Todos los registros cuyo segundo nombre es Alexander
select * from users where name like '% Alexander';

-- 5. Cambiar el nombre del registro con id = 1, por tu nombre Ej:'Fernando Herrera'
update users
set name = 'Fernando Herrera'
where id = 1;

-- 6. Borrar el último registro de la tabla
delete from users where id = (select max(id) from users);

-- 7. Obtener el firstname y el lastname por columnas,
--    luego actualizar las columnas
select 
	substring(name, 0, POSITION(' ' in name)) as firstname,
	substring(name, POSITION(' ' in name) + 1, char_length(name)) as lastname
from users;

select 
	substring(name, 0, POSITION(' ' in name)) as firstname,
	substring(name, POSITION(' ' in name) + 1, char_length(name)) as lastname
from users;

update users
set
	firstname = substring(name, 0, POSITION(' ' in name)),
	lastname = substring(name, POSITION(' ' in name) + 1, char_length(name));
	
select * from users;