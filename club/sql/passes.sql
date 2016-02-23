select
parts-1 as passes,
count(*) as n
from club.shots s
join club.games g
on (g.game_id)=(s.game_id)
where g.year>=2008
group by passes
order by passes;

copy (
select
parts-1 as passes,
count(*) as n
from club.shots s
join club.games g
on (g.game_id)=(s.game_id)
where g.year>=2008
group by passes
order by passes
) to '/tmp/passes.csv' csv header;
