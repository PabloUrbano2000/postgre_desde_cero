-- delete from followers cascade;
-- select * from pg_sequences;
-- database followers_suggestions-db.sql
insert into followers (leader_id, follower_id)
values 	(1, 2), (1, 3),
		(2, 6),
		(6, 9),
		(9, 1),
		(3, 8), (3, 11);

select f.*, leader.name, following.name as leader from followers f
inner join "user" leader on f.leader_id = leader.id
inner join "user" following on f.leader_id = following.id;

select follower_id from followers where leader_id = 1;

-- obtener a los que siguen las personas que yo sigo
-- recursividad manual
select * from followers where leader_id in (select follower_id from followers where leader_id = 1);