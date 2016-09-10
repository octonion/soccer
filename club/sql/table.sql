select
g.club_name as team,
count(*) as p,
sum(
case when g.club_id=g.home_team_id
     and (home_goals > away_goals) then 1
     when club_id=away_team_id
     and (home_goals < away_goals) then 1
else 0
end) as w,
sum(
case when (home_goals=away_goals) then 1
else 0
end) as d,
sum(
case when club_id=home_team_id
     and (home_goals < away_goals) then 1
     when club_id=away_team_id
     and (home_goals > away_goals) then 1
else 0
end) as l,
sum(
case when g.club_id=g.home_team_id then home_goals
     else away_goals
end) as gf,
sum(
case when g.club_id=g.home_team_id then away_goals
     else home_goals
end) as ga,
sum(
case when g.club_id=g.home_team_id then home_goals-away_goals
     else away_goals-home_goals
end) as gd,

sum(
case when g.club_id=g.home_team_id
       and (home_goals > away_goals) then 3
     when club_id=away_team_id
       and (home_goals < away_goals) then 3
     when (home_goals=away_goals) then 1
else 0
end) as pts

from club.games g
where
    not(g.date='LIVE')
and g.league_key = 'english+premier+league'
and g.competition='Prem'
and g.year=2016
and g.date::date <= current_date
and g.home_goals is not null
and g.away_goals is not null
group by g.club_name
order by pts desc,gd desc,gf desc;
