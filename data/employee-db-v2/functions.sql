-- funciones de sistema
select greatest(1, 2, 3, 30, 5);

select COALESCE(null, 'sdsds');

-- https://www.postgresql.org/docs/current/sql-createfunction.html
create or replace function greet_employee(employee_name varchar)
returns VARCHAR
as $$
--DECLARE
BEGIN
	return 'Hola Pe ' || employee_name;
END;
$$
LANGUAGE plpgsql;

select public.greet_employee('perro');

select public.greet_employee(e.first_name) from employees e;

-- funcion con multiples variables
create or replace function max_raise(empl_id int)
returns numeric(8,2)
as $$
DECLARE possible_raise numeric(8,2);
BEGIN
	select
	max_salary - salary into possible_raise
	from employees e
	inner join jobs on jobs.job_id = e.job_id
	where e.employee_id = empl_id;
	return possible_raise;
END;
$$
LANGUAGE plpgsql;

select 	e.employee_id,
		e.first_name,
		e.salary,
		public.max_raise(e.employee_id)
from employees e;



create or replace function max_raise_2(empl_id int)
returns numeric(8,2)
as $$
DECLARE
	employee_job_id int;
	current_salary numeric(8,2);
	job_max_salary numeric(8,2);
	possible_raise numeric(8,2);
BEGIN
	-- Tomar el puesto de trabajo y el salario
	select 
		e.job_id,
		e.salary into employee_job_id, current_salary
	from employees e where e.employee_id = empl_id;
	-- Tomar el max salary, acorde a su job
	select
		max_salary into job_max_salary
	from jobs where job_id = employee_job_id;
	-- Calculos
	possible_raise = job_max_salary - current_salary;
	
	if (possible_raise < 0) then
		raise exception 'Persona con salario mayor a max_salary: %', empl_id;
	end if;
	return possible_raise;
END;
$$
LANGUAGE plpgsql;


select 	e.employee_id,
		e.first_name,
		e.salary,
		public.max_raise_2(e.employee_id)
from employees e;




-- rowtype
create or replace function max_raise_3(empl_id int)
returns numeric(8,2)
as $$
DECLARE
	selected_employee employees%rowtype;
	selected_job jobs%rowtype;
	possible_raise numeric(8,2);
BEGIN
	-- Tomar el puesto de trabajo y el salario
	select 
		*
	from employees
	into selected_employee
	where employee_id = empl_id;
	-- Tomar el max salary, acorde a su job
	select
		*
	from jobs 
	into selected_job
	where job_id = selected_employee.job_id;
	-- Calculos
	possible_raise = selected_job.max_salary - selected_employee.salary;
	
	if (possible_raise < 0) then
		raise exception 'Persona con salario mayor a max_salary: id:%, %', selected_employee.employee_id, selected_employee.first_name;
	end if;
	return possible_raise;
END;
$$
LANGUAGE plpgsql;


select 	e.employee_id,
		e.first_name,
		e.salary,
		public.max_raise_3(e.employee_id)
from employees e;
