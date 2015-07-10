begin;

create temporary table r (
       rk	 serial,
       team 	 text,
       team_id	 text,
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
sf.team_id,
sf.team_id,
sf.year,
sf.strength::numeric(5,3) as str,
offensive::numeric(5,3) as ofs,
defensive::numeric(5,3) as dfs,
schedule_strength::numeric(5,3) as sos
from uefa._schedule_factors sf
where sf.year in (2015)
order by str desc);

select
rk,team,str,ofs,dfs,sos
from r
order by rk asc;

commit;
