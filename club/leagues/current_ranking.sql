begin;

create temporary table r (
       rk	        serial,
       team 	 	text,
       team_id   	integer,
       league_key	text,
       league		text,
       year	 	integer,
       str	 	numeric(5,3),
       ofs	 	numeric(5,3),
       dfs	 	numeric(5,3),
       sos	 	numeric(5,3)
);

insert into r
(team,team_id,league_key,league,year,str,ofs,dfs,sos)
(
select
t.club_name,
sf.team_id,
t.league_key,
l.league_name,
sf.year,
(sf.strength*o.exp_factor/d.exp_factor)::numeric(5,3) as str,
(offensive*o.exp_factor)::numeric(5,3) as ofs,
(defensive*d.exp_factor)::numeric(5,3) as dfs,
schedule_strength::numeric(5,3) as sos
from club._schedule_factors sf
join club.teams t
  on (t.year,t.club_id)=(sf.year,sf.team_id)
join club._factors o
  on (o.parameter,o.level)=('offense_league',t.league_key)
join club._factors d
  on (d.parameter,d.level)=('defense_league',t.league_key)
join club.leagues l
  on (l.league_key)=(t.league_key)
where sf.year in (2017)
order by str desc);

select
rk,team,league,str,ofs,dfs,sos
from r
order by rk asc;

copy
(
select
rk,team,league,str,ofs,dfs,sos
from r
order by rk asc
) to '/tmp/current_ranking.csv' csv header;

commit;
