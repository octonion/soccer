select
year,
gender_id,
cup_name,
count(*) as n
from fifa.games
where
score is null
group by year,gender_id,cup_name
order by year,gender_id,cup_name;

