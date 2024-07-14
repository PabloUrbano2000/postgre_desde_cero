-- funciones con retorno tablas
create or replace function public.country_region()
returns table (id character(2), name varchar(40), region varchar(25))
as $$
begin
	return query
	select 
		country_id, country_name, region_name
	from countries
	inner join regions on countries.region_id = regions.region_id;
end;
$$
LANGUAGE plpgsql;

select * from country_region();

-- PROCEDIMIENTOS ALMACENADOS
drop PROCEDURE if exists sp_insert_region;

create or replace procedure sp_insert_region(int, varchar)
as $$
BEGIN
	insert into regions(region_id, region_name) values ($1, $2);
	-- el raise notice nomás genera un mensaje en consola mas no corta la ejecución
	raise notice 'Variable 1: %, %', $1, $2;
	-- rollback;
	commit;
END;
$$ LANGUAGE plpgsql;

-- delete from regions where region_id = 5;
call sp_insert_region(5, 'Central América');

-- verificamos la insercción
select * from regions;



select
	current_date as date,
	salary,
	max_raise(employee_id),
	max_raise(employee_id) * 0.05 as amount,
	5 as percentage
from employees;

create or replace procedure sp_controlled_raise(percentage numeric)
as
$$
declare 
	real_percentage numeric(8,2);
	total_employees int;
BEGIN
	real_percentage = percentage / 100; --5% = 0.05;
	-- mantener el histórico
	insert into raise_history(date, employee_id, base_salary, amount, percentage)
	select
		current_date as date,
		employee_id,
		salary,
		max_raise(employee_id) * real_percentage as amount,
		percentage
	from employees;
	-- impactar la tabla de empleados
	update employees
	set salary = salary + max_raise(employee_id) * real_percentage;
	commit;
	select count(*) into total_employees from employees;
	raise notice 'Afectados % empleados', total_employees;
END;
$$
LANGUAGE plpgsql;

call sp_controlled_raise(1);

select * from employees;

-- el aumento agregado es el porcentaje de lo máximo que se le puede aumentar
select * from raise_history;