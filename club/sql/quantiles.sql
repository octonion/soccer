copy (
select
pts
from club.sims
where rank=1
) to '/tmp/points.csv' csv header;

