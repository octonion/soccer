select
team,
avg(rank)::numeric(3,1) as rank,
avg(w)::numeric(3,1) as w,
avg(d)::numeric(3,1) as d,
avg(l)::numeric(3,1) as l,
avg(pts)::numeric(4,1) as pts
from club.sims group by team order by team;

copy (
select
team,
avg(rank)::numeric(3,1) as rank,
avg(w)::numeric(3,1) as w,
avg(d)::numeric(3,1) as d,
avg(l)::numeric(3,1) as l,
avg(pts)::numeric(4,1) as pts
from club.sims group by team order by team
) to '/tmp/sim_table.csv' csv header;
