select
year,
gender_id,
cup_name,
'http://www.fifa.com/live/world-match-centre/library/fixtures/bymonth/idcupseason='||cupseason_id||'/date='||data_matchdate||'/_matchesBoxed.html' as url,
count(*) as n
from fifa.games
where score is null
group by year,gender_id,cupseason_id,data_matchdate,cup_name,url
order by year,gender_id,cup_name;
