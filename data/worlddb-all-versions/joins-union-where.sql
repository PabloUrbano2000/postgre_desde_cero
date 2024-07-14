
-- UNIONS
select code, name, '123' from continent where name like '%America%'
union
select 1, 'otra cosa', name from continent where code in (3,5)
order by name asc;

-- WHERE (es volatil, es propenso a errores)
select
	a.name country, b.name continent
from country a, continent b
	where a.continent = b.code
	order by b.name asc;

-- JOINS
-- inner join
select
	a.name country, b.name continent
from country a
inner join continent b on a.continent = b.code
order BY
	a."name" asc;
	
-- reiniciar sequence
alter SEQUENCE continent_code_seq restart WITH 8;

-- full outer join
select a.name as country, a.continent as continentCode, b.name as continentName
from country a full outer join continent b on a.continent = b.code
order by a.name desc;


-- right outer join
select a.name as country, a.continent as continentCode, b.name as continentName
from country a right outer join continent b on a.continent = b.code
where a.continent is null
order by a.name desc;







-- Count Union - Tarea
-- Total |  Continent
-- 5	  | Antarctica
-- 28	  | Oceania
-- 46	  | Europe
-- 51	  | America
-- 51	  | Asia
-- 58	  | Africa

(select count(*) as total, b.name as continent from country a
right outer join continent b on a.continent = b.code
where b.name not like '%America'
GROUP by b.name
order by count(*) asc)
union
(select count(*) total, 'America' as continent from country c
right outer join continent d on c.continent = d.code
where d.name like '% America'
order by count(*) asc) order by total asc, continent asc;



-- Quiero que me muestren el pais con más ciudades
select count(*) total, a."name" pais from country a
inner join city b on a.code = b.countrycode
group by a.name
order by count(*) desc
limit 1;


select * from countrylanguage where isofficial = true;

select * from country;

select * from continent;


-- ¿Cuales son los lenguajes oficionales por continente?
select DISTINCT d.name, c."name" from countrylanguage a
inner join country b on a.countrycode = b.code
inner join continent c on b.continent = c.code
inner join LANGUAGE d on a.languagecode = d.code
where a.isofficial = true
order by c."name" asc;


-- ¿Cuantos idiomas oficiales se hablan por continente?
select count(*), continent from
(select DISTINCT a."language", c."name" continent from countrylanguage a
inner join country b on a.countrycode = b.code
inner join continent c on b.continent = c.code
where a.isofficial = true
order by c."name" asc) as totales
GROUP by continent;

