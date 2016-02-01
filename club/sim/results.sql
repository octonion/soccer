
select team,rank,count(*) as n
from club.sims
group by team,rank
order by rank asc, n desc;

copy (
select team,rank,count(*) as n
from club.sims
group by team,rank
order by rank asc, n desc
) to '/tmp/results.csv' csv header;

