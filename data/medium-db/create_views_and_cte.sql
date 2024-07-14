
-- creación de vista
create or replace view comments_per_week
as
select
	date_trunc('week', posts.created_at) as weeks,
	sum(claps.counter) as total_claps,
	count(distinct posts.post_id) as number_of_posts,
	count(*) as number_of_claps
	from posts
inner join claps on claps.post_id = posts.post_id
group by weeks
order by weeks desc;

drop view comments_per_week;


-- llamado de vista
select * from comments_per_week;


-- creación de vista MATERIALIZADA
-- las vistas materializadas podemos verla como
-- una copia de la tabla
-- se queda con el último commit realizado en
-- su creación, quiere decir que no se actualiza
-- estas quedan en memoria por lo que ocupa espacio
-- estas sirven para poder obtener información rápidamente
create MATERIALIZED view comments_per_week_mat
as
select
	date_trunc('week', posts.created_at) as weeks,
	sum(claps.counter) as total_claps,
	count(distinct posts.post_id) as number_of_posts,
	count(*) as number_of_claps
	from posts
inner join claps on claps.post_id = posts.post_id
group by weeks
order by weeks desc;

select * from comments_per_week_mat;

-- para actualizar la información de la vista materializada
refresh materialized view comments_per_week_mat;


-- create or replace view post_per_week
-- as
-- select
-- 	date_trunc('week', posts.created_at) as weeks,
-- 	sum(claps.counter) as total_claps,
-- 	count(distinct posts.post_id) as number_of_posts,
-- 	count(*) as number_of_claps
-- 	from posts
-- inner join claps on claps.post_id = posts.post_id
-- group by weeks
-- order by weeks desc;

-- drop view post_per_week;

-- para actualizar una vista sin eliminarla
alter view comments_per_week rename to posts_per_week;

-- actualizar una vista materializada sin eliminarla
alter materialized view comments_per_week_mat rename to posts_per_week_mat;


-- Common table expresión, creación de tablas virtuales (temporales)
-- https://www.postgresql.org/docs/current/queries-with.html
with posts_week_2024 as (
select
	date_trunc('week', posts.created_at) as weeks,
	sum(claps.counter) as total_claps,
	count(distinct posts.post_id) as number_of_posts,
	count(*) as number_of_claps
	from posts
inner join claps on claps.post_id = posts.post_id
group by weeks
order by weeks desc
)

select * from posts_week_2024
where weeks between '2024-01-01' and '2024-12-31' and total_claps >=600;

-- CTE con varios querys
with claps_per_post as (
select post_id, sum(counter) from claps
group by post_id
), posts_from_2023 as (
select * from posts where created_at BETWEEN '2023-01-01' and '2023-12-31'
)

-- haciendo la query solo devuelve el primer query que se encuentra dentro de la tabla virtual
select * from claps_per_post
where claps_per_post.post_id in (select post_id from posts_from_2023);


-- CTE Recursivo
-- nombre de la tabla en memoria
-- campos que vamos a tener
with recursive countdown(val) as (
-- inicialización => el primer nivel, o valores iniciales
-- 	values(5)
	select 5 as val
	UNION
	-- query recursivo
	select val - 1 from countdown
	where val > 1
)

-- select de los campos
select * from countdown;

-- contador ascendente
with recursive cronometro(val) as (
	select 1 as val
	union
	select val + 1 from cronometro
	where val < 10
)

select * from cronometro;

-- contador multiplicador
with recursive multiplication_table(base, val, result) as (
    -- init
    select
        5 as base,
        1 as val,
        5 * 1 as result
    union
        -- recursiva
    select
        5 as base,
        val + 1,
        (val + 1) * base
    from
        multiplication_table
    where
        val < 10
)
select * from multiplication_table;

-- recursividad en empleados por subordinados
drop table if exists employees;
create table employees (
	id serial primary key,
	name varchar(200),
	reports_to int default null
);


insert into employees(name, reports_to) values
('Jefe Carlos', null),
('Subjefe Susana', 1),
('Subjefe Juan', 1),
('Gerente Pedro', 3),
('Gerente Melissa', 3),
('Gerente Carmen', 2),
('SubGerente Ramiro', 5),
('Programador Fernando', 7),
('Programador Eduardo', 7),
('Presidente Karla', null),
('Jr Mariano', 8);

with recursive bosses as (
	-- init
	select id, name, reports_to from employees where id in (1)
	union
	--recursive
	select employees.id, employees.name, employees.reports_to
	from employees
	-- gracias al inner join es donde se empieza a formar la recursividad (en la primera vuelta
	-- buscará por el id 1, luego por el id 2 y 3, luego 4, 5 y 6, luego 7....)
		inner join bosses on bosses.id = employees.reports_to
)
select * from bosses;

-- recursividad con nivel de profundidad
with recursive bosses as (
	-- init, depth: profundidad
	select id, name, reports_to, 1 as depth from employees where id in (1)
	union
	--recursive
	select employees.id, employees.name, employees.reports_to, depth + 1
	from employees
	-- gracias al inner join es donde se empieza a formar la recursividad (en la primera vuelta
	-- buscará por el id 1, luego por el id 2 y 3, luego 4, 5 y 6, luego 7....)
	inner join bosses on bosses.id = employees.reports_to
	where DEPTH < 3
)
select * from bosses;

-- recursividad con nivel de profundidad (solo nombres de empleados)
with recursive bosses as (
	-- init, depth: profundidad
	select id, name, reports_to, 1 as depth from employees where id in (1)
	union
	--recursive
	select e.id, e.name, e.reports_to, depth + 1
	from employees e
	-- gracias al inner join es donde se empieza a formar la recursividad (en la primera vuelta
	-- buscará por el id 1, luego por el id 2 y 3, luego 4, 5 y 6, luego 7....)
	inner join bosses b on b.id = e.reports_to
	where DEPTH < 3
)
select b.*, e.name from bosses b
left outer join employees e on e.id = b.reports_to
order by b.depth;
-- nota: el orden es mejor hacerlo por el nivel de profundidad 
