-- Nombre, apellido e IP, donde la última conexión se dió de 221.XXX.XXX.XXX
select
  first_name, last_name, last_connection
from users
where last_connection like '221.%.%.%';

-- Nombre, apellido y seguidores(followers) de todos a los que lo siguen más de 4600 personas
select
  first_name, last_name, followers
from users
where following > 4600;

-- Obtener el dominio de correo y la cantidad de veces que se repite
select count(*),
	SUBSTRING(email, POSITION('@' in email) + 1, CHARACTER_LENGTH(email)) as domain
from users
GROUP by domain
having count(*) > 1;