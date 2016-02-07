
select
team,avg(pts)::numeric(3,1) as avg,
min(pts) as min,
max(pts) as max from club.sims
group by team
order by team;

copy (
select
team,avg(pts)::numeric(3,1) as avg,
min(pts) as min,
max(pts) as max from club.sims
group by team
order by team
) to '/tmp/team_table.cvs' csv header;
