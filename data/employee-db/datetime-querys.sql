-- https://www.postgresql.org/docs/8.1/functions-datetime.html
-- https://www.postgresqltutorial.com/postgresql-date-functions/postgresql-date_part/
select 	now(),
		current_date,
		current_time,
		current_user,
		date_part('hours', now()),
		date_part('minutes', now()),
		date_part('seconds', now()),
		date_part('days', now()),
		date_part('months', now()),
		date_part('years', now());
		
select * from employees
where hire_date> date('1998-02-05')
order by hire_date desc;

select 	max(hire_date) as mas_nuevo,
		min(hire_date) as mas_antiguo
from employees;

select * from employees
where hire_date BETWEEN '1999-01-01' and '2001-01-04'
order by hire_date asc;


select 	max(hire_date),
-- 		max(hire_date) + interval '1 days' as days,
-- 		max(hire_date) + interval '1 month' as month,
-- 		max(hire_date) + interval '1 year' as year,
-- 		max(hire_date) + interval '1 year' + interval '1 day',
		date_part('year', now()),
		make_interval(years:= date_part('year', now())::integer),
		max(hire_date) + make_interval(years:=23)
from employees;


select
	hire_date,
	make_interval(years:=2020 - extract(years from hire_date):: integer) as manual,
	make_interval(years:=date_part('years', current_date)::integer) as actual,
		make_interval(years:=date_part('years', current_date)::integer - 2000) as actual,
	make_interval(years:=date_part('years', current_date)::integer - extract(years from hire_date):: integer) as diferenciado
from employees
order by hire_date desc;


-- actualizar la fecha de contratacion sumandole los años del año actual
update employees
set hire_date = hire_date + make_interval(years:=date_part('years', current_date)::integer - 2000);



select
	first_name,
	last_name,
	hire_date,
	case
		when hire_date > now() - INTERVAL '1 year' then 'Rango A'
		when hire_date > now() - INTERVAL '3 year' then 'Rango B'
		when hire_date > now() - INTERVAL '6 year' then 'Rango C'
		else 'Rango D'
	end as rango_antiguedad
from employees order by hire_date desc;