select
g.location,
(
sum(
case when g.location='Home' and g.team_score>g.opponent_score then 1
     when g.location='Away' and g.team_score<g.opponent_score then 1
     when g.location='Neutral' then 0.5
     else 0 end
)::float/
count(*)
)::numeric(3,2) as win_pct,
count(*) as n
from ncaa.games g

where

TRUE
and g.game_date is not null
and not(g.game_date='')
and extract(month from g.game_date::date) in (3,4)
group by g.location
order by g.location;
