drop table if exists "user";

create table "user" (
	id serial primary key,
	username varchar(50) null,
	password text null,
	last_login TIMESTAMP null
);

insert into "user" (username, password)
values ('elmaldy', '123456');

select * from "user";


-- encriptar contraseña
-- https://www.postgresql.org/docs/current/pgcrypto.html
create extension "pgcrypto";
-- drop extension "pgcrypto";

insert into "user" (username, password)
values(
		'elmaldy',
		crypt('123456', gen_salt('bf'))
);

select * from "user"
where 	username = 'elmaldy' AND
		password = crypt('123456', password);
