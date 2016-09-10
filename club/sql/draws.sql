select
year,
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

--sum(
--case not(home_goals=away_goals) then 1
--else 0
--end) as w,
sum(
case when (home_goals=away_goals) then 1
else 0
end)::float/count(*)

from club.games g
where
    not(g.date='LIVE')
and g.league_key = 'english+premier+league'
and g.competition='Prem'
--and g.year=2016
and g.date::date <= current_date
and g.home_goals is not null
and g.away_goals is not null
--and g.year >= 2010
group by g.year
order by g.year;
--group by g.club_name;
