
select
team,
avg(rank)::numeric(3,1) as rnk_avg,
min(rank) as rnk_min,
max(rank) as rnk_max,
avg(pts)::numeric(3,1) as pts_avg,
min(pts) as pts_min,
max(pts) as pts_max
from club.sims
group by team
order by team;

copy (
select
team,
avg(rank)::numeric(3,1) as rnk_avg,
min(rank) as rnk_min,
max(rank) as rnk_max,
avg(pts)::numeric(3,1) as pts_avg,
min(pts) as pts_min,
max(pts) as pts_max
from club.sims
group by team
order by team
) to '/tmp/team_table.cvs' csv header;
