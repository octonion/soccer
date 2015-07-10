begin;

create temporary table r (
       team_id	 integer,
       div	 	 integer,
       year	 	 integer,
       str	 	 numeric(5,3),
       ofs	 	 numeric(5,3),
       dfs	 	 numeric(5,3),
       sos	 	 numeric(5,3)
);

insert into r
(team_id,div,year,str,ofs,dfs,sos)
(
select
t.team_id,
t.div_id as div,
sf.year,
(sf.strength*o.exp_factor/d.exp_factor)::numeric(5,3) as str,
(offensive*o.exp_factor)::numeric(5,3) as ofs,
(defensive*d.exp_factor)::numeric(5,3) as dfs,
schedule_strength::numeric(5,3) as sos
from uefa._schedule_factors sf
left outer join uefa.teams_divisions t
  on (t.team_id,t.year)=(sf.team_id,sf.year)
left outer join uefa._factors o
  on (o.parameter,o.level)=('o_div',t.div_id::text)
left outer join uefa._factors d
  on (d.parameter,d.level)=('d_div',t.div_id::text)
--where sf.year in (2008)
where
TRUE
and t.team_id is not null
order by str desc);

select
year,
exp(avg(log(str)))::numeric(5,3) as str,
exp(avg(log(ofs)))::numeric(5,3) as ofs,
exp(-avg(log(dfs)))::numeric(5,3) as dfs,
exp(avg(log(sos)))::numeric(5,3) as sos,
count(*) as n
from r
group by year
order by year asc;

select
year,
div,
exp(avg(log(str)))::numeric(5,3) as str,
exp(avg(log(ofs)))::numeric(5,3) as ofs,
exp(-avg(log(dfs)))::numeric(5,3) as dfs,
exp(avg(log(sos)))::numeric(5,3) as sos,
--avg(str)::numeric(5,3) as str,
--avg(ofs)::numeric(5,3) as ofs,
--(1/avg(dfs))::numeric(5,3) as dfs,
--avg(sos)::numeric(5,3) as sos,
count(*) as n
from r
where div is not null
group by year,div
order by year asc,str desc;

select * from r
where div is null;
--and year=2008;

commit;
