

-- ¿Cuál es el idioma (y código del idioma) oficial más hablado por diferentes países en Europa?

select * from countrylanguage where isofficial = true;

select * from country;

select * from continent;

Select * from "language";

select count(*) total, lg."name", lg.code from countrylanguage cl
inner join language lg on cl.languagecode = lg.code
inner join country c on cl.countrycode = c.code
inner join continent ct on c.continent = ct.code
where ct."name" = 'Europe' and cl.isofficial = true
GROUP by  lg."name", lg.code
order by total desc
limit 1;




-- Listado de todos los países cuyo idioma oficial es el más hablado de Europa 
-- (no hacer subquery, tomar el código anterior)
select * from country a
inner join countrylanguage b on a.code = b.countrycode
where a.continent = 4
and b.isofficial = true
and b.languagecode = 135;


