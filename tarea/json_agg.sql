select 
	json_agg( json_build_object(
	  'user', comments.user_id,
	  'comment', comments.content
	))
from comments where comment_parent_id = 1;



create or replace function sayHello(username varchar) returns varchar
as
$$
begin
	return 'Hola ' || username;
end;
$$
LANGUAGE plpgsql;

select sayHello(users."name"), users.name from users;



select 
	json_agg( json_build_object(
	  'user', comments.user_id,
	  'comment', comments.content
	))
from comments where comment_parent_id = 1;

create or replace function comment_replies(id integer)
returns json
as
$$
Declare result json;
BEGIN
select 
	json_agg( json_build_object(
	  'user', comments.user_id,
	  'comment', comments.content
	)) into result
from comments where comment_parent_id = id;
return result;
end;
$$
LANGUAGE plpgsql;

select comment_replies(2);

-- usando la función
select 
	a.*,
	comment_replies(a.comment_id) as replies
from "comments" a
where a.comment_parent_id is null;