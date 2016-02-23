select
league_key,
(sum(case when result_text like '%Scored' then 1.0 else 0.0 end)/count(*))::numeric(4,3) as p
from club.parts
where
    result_text not like '%:%'
and result_text like 'Penalty%'
group by league_key
order by p;
