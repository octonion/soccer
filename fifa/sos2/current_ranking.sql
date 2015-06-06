begin;

create temporary table r (
       rk	 serial,
       team 	 text,
       team_id	 text,
       str	 float,
       ofs	 float,
       dfs	 float,
       sos	 float
);

insert into r
(team,team_id,str,ofs,dfs,sos)
(
select
coalesce(t.team_name,sf.team_id),
sf.team_id,
sf.strength as str,
sf.offensive as ofs,
sf.defensive as dfs,
sf.schedule_strength as sos
from fifa._schedule_factors sf
left join fifa.teams t
  on (t.gender_id,t.team_id)=('women',sf.team_id)
order by str desc);

select
rk,
team,
str::numeric(5,2),
ofs::numeric(5,2),
dfs::numeric(5,2),
sos::numeric(5,2)
from r
order by rk asc;

select
row_number() over (order by str desc nulls last) as rk,
team,
str::numeric(5,2),
ofs::numeric(5,2),
dfs::numeric(5,2),
sos::numeric(5,2)
from r
order by rk asc;

copy (
select
rk,
team,
str::numeric(5,2),
ofs::numeric(5,2),
dfs::numeric(5,2),
sos::numeric(5,2)
from r
order by rk asc
) to '/tmp/current_ranking.csv' csv header;

commit;
