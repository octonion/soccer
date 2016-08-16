begin;

create temporary table r (
       rk	 serial,
       team 	 text,
       team_id   integer,
       year	 integer,
       str	 numeric(5,3),
       ofs	 numeric(5,3),
       dfs	 numeric(5,3),
       sos	 numeric(5,3)
);

insert into r
(team,team_id,year,str,ofs,dfs,sos)
(
select
t.club_name,
sf.team_id,
sf.year,
(sf.strength)::numeric(5,3) as str,
(offensive)::numeric(5,3) as ofs,
(defensive)::numeric(5,3) as dfs,
schedule_strength::numeric(5,3) as sos
from club._schedule_factors sf
join club.teams t
  on (t.year,t.club_id)=(sf.year,sf.team_id)
where sf.year in (2016)
order by str desc);

select
rk,team,str,ofs,dfs,sos
from r
order by rk asc;

copy
(
select
rk,team,str,ofs,dfs,sos
from r
order by rk asc
) to '/tmp/current_ranking.csv' csv header;

commit;
