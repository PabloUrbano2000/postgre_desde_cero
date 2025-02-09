
drop table if exists users;
drop table if exists users2;
drop table if exists user3;
drop table if exists users4;
drop table if exists usersDual;

create table "users" (
	user_id serial primary key,
	username varchar
);

-- verificar las secuencias
select * from pg_sequences;

-- identity por defecto es similar a serial
create table "users2" (
	user_id integer generated by default as identity  primary key,
	username varchar
);

-- identity nos da más control
create table "users3" (
	user_id integer generated always as identity  primary key,
	username varchar
);
-- para tener un inicializador de id's
create table "users4" (
	user_id integer generated always as identity
	(start with 100 increment by 2) primary key,
	username varchar
);


-- llave compuesta
create table usersDual (
	id1 int,
	id2 int,
	primary key (id1, id2) -- la combinación de ambos va ser la llave primaria
);

-- UUID: https://www.postgresql.org/docs/current/uuid-ossp.html
create extension if not exists "uuid-ossp";
-- drop extension "uuid-ossp";

select gen_random_uuid(), uuid_generate_v4();

-- crear tabla con id de uuid v4
create table "users5" (
	user_id uuid default uuid_generate_v4() primary key,
	username varchar
);


create sequence user_sequence;

drop sequence user_sequence;

select 
	currval('user_sequence'),
	nextval('user_sequence'),
	currval('user_sequence');

create table users6 (
	user_id integer primary key default nextval('user_sequence'),
	username varchar
);
