select
g.team_name as team,
count(*) as p,
sum(
case when (team_score > opponent_score) then 1
else 0
end) as w,
sum(
case when (team_score=opponent_score) then 1
else 0
end) as d,
sum(
case when (team_score < opponent_score) then 1
else 0
end) as l,
sum(team_score) as gf,
sum(opponent_score) as ga,
sum(team_score-opponent_score) as gd,

sum(
case when (team_score > opponent_score) then 3
     when (team_score=opponent_score) then 1
else 0
end) as pts

from club.results g
join club.intraleague_keys ik
  on (ik.league_key,ik.intraleague_key)=(g.team_league_key,g.competition)
  
where
    g.team_league_key = 'dummy_league_key'

and g.year=2017
and g.game_date <= current_date
and g.team_score is not null
and g.opponent_score is not null
and g.status not like '%'''

group by g.team_name
order by pts desc,gd desc,gf desc;
