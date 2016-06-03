begin;

select
r.team_name,p::numeric(4,3)
from fifa.men_rounds r
join fifa.teams t
  on (t.team_id,t.gender_id)=(r.team_id,'men')
where round_id=4
order by p desc;

copy
(
select
r.team_name,p::numeric(4,3)
from fifa.men_rounds r
join fifa.teams t
  on (t.team_id,t.gender_id)=(r.team_id,'men')
where round_id=4
order by p desc
) to '/tmp/champion_p.csv' csv header;

commit;
