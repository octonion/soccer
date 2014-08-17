select

r.field,
(
sum(
case when r.team_score>r.opponent_score and r.field='offense_home' then 1
     when r.team_score<r.opponent_score and r.field='defense_home' then 1
     else 0 end)::float/
count(*)
)::numeric(4,2) as naive,
count(*)
from ncaa.results r
join ncaa._schedule_factors t
  on (t.year,t.school_id)=(r.year,r.school_id)
join ncaa._schedule_factors o
  on (o.year,o.school_id)=(r.year,r.opponent_id)
join ncaa._factors f
  on (f.parameter,f.level)=('field',r.field)
where

TRUE

-- test March and April

and not(r.field='none')

and extract(month from r.game_date) in (3,4)

group by r.field;
--,r.field
--order by r.year,r.field;

