begin;

create temporary table r (
       rk	 serial,
       team 	 text,
       team_id	 text,
       year	 integer,
       str	 float,
       ofs	 float,
       dfs	 float,
       sos	 float
);

insert into r
(team,team_id,year,str,ofs,dfs,sos)
(
select
sf.team_id,
sf.team_id,
sf.year,
sf.strength as str,
sf.offensive as ofs,
sf.defensive as dfs,
sf.schedule_strength as sos
from fifa._schedule_factors sf
--join fifa.teams s
--  on (s.team_id)=(sf.team_id)
where sf.year in (2014)
order by str desc);

select
rk,
team,
str::numeric(4,2),
ofs::numeric(4,2),
dfs::numeric(4,2),
sos::numeric(4,2)
from r
order by rk asc;

select
row_number() over (order by str desc nulls last) as rk,
team,
str::numeric(4,2),
ofs::numeric(4,2),
dfs::numeric(4,2),
sos::numeric(4,2)
from r
order by rk asc;

copy (
select
rk,
team,
str::numeric(4,2),
ofs::numeric(4,2),
dfs::numeric(4,2),
sos::numeric(4,2)
from r
order by rk asc
) to '/tmp/current_ranking.csv' csv header;

commit;
