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
where
    g.team_league_key = 'english+premier+league'
and g.competition='Prem'
and g.year=2016
and g.game_date <= current_date
and g.team_score is not null
and g.opponent_score is not null
group by g.team_name
order by pts desc,gd desc,gf desc;
