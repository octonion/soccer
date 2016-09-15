begin;

create temporary table r (
       rk	        serial,
       lg		text,
       str		numeric(5,3),
       ofs	 	numeric(5,3),
       dfs	 	numeric(5,3)
);

insert into r
(lg,str,ofs,dfs)
(
select
l.league_name as lg,
(o.raw_factor-d.raw_factor)::numeric(5,3) as str,
(o.raw_factor)::numeric(5,3) as ofs,
(-d.raw_factor)::numeric(5,3) as dfs
from club._factors o
join club._factors d
  on (d.level)=(o.level)
join club.leagues l
  on (l.league_key)=(o.level)
where o.parameter='offense_league'
and d.parameter='defense_league'
order by str desc
);

select
rk,lg,str,ofs,dfs
from r
order by rk asc;

copy
(
select
rk,lg,str,ofs,dfs
from r
order by rk asc
) to '/tmp/league_ranking.csv' csv header;

commit;
