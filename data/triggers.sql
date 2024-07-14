drop table if exists "user";

create table "user" (
	id serial primary key,
	username varchar(50) null,
	password text null,
	last_login TIMESTAMP null
);

drop table if exists "session_failed";
create table session_failed(
	id serial primary key,
	username varchar(50) null,
	"when" TIMESTAMP
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
		


select count(*) from "user"
where 	username = 'elmaldy' AND
		password = crypt('123456', password);
		
create or replace procedure user_login(user_name varchar, user_password varchar)
as
$$
DECLARE
	was_found BOOLEAN;
BEGIN
	select count(*) into was_found from "user"
	where 	username = user_name AND
			password = crypt(user_password, password);
	if (was_found = false) THEN
		insert into "session_failed" (username, "when")
		values (user_name, now());
		COMMIT;
		-- raise exception por defecto lanza un rollback
		raise exception 'Usuario y contraseña no son correctos';
	end if;
	
	update "user" set last_login = now() where username = user_name;
	COMMIT;
	raise notice 'Usuario encontrado %', was_found;
END;
$$
LANGUAGE plpgsql;

call user_login('elmaldy','123456');
call user_login('elmaldy','1sf23456');


drop table if exists "session";

create table "session" (
	id serial primary key,
	user_id int null,
	last_login TIMESTAMP null
);

-- TRIGGERS
-- https://www.postgresql.org/docs/current/sql-createtrigger.html
create or replace trigger trg_create_session
after update on "user"
for each row
when (OLD.last_login is DISTINCT from NEW.last_login)
execute function create_session_log();

create or replace function create_session_log()
returns trigger
as $$
BEGIN
	insert into "session" (user_id, last_login) values (NEW.id, now());
	return NEW;
END;
$$ LANGUAGE plpgsql;

call user_login('elmaldy','123456');

select * from "sessions";