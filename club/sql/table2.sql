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
end) as pts,
(coalesce(sc.n,0)::float/100000::float)::numeric(4,3) as champ,
((coalesce(s18.n,0)+coalesce(s19.n,0)+coalesce(s20.n,0))::float/100000::float)::numeric(4,3) as rlg

from club.games g
left join club.seeds sc
  on (g.club_name,1)=(sc.team_name,sc.rank)
left join club.seeds s18
  on (g.club_name,18)=(s18.team_name,s18.rank)
left join club.seeds s19
  on (g.club_name,19)=(s19.team_name,s19.rank)
left join club.seeds s20
  on (g.club_name,20)=(s20.team_name,s20.rank)
where
    not(g.date='LIVE')
and g.league_key = 'barclays+premier+league'
and g.competition='Prem'
and g.year=2015
and g.date::date <= current_date
and g.home_goals is not null
and g.away_goals is not null
group by g.club_name,champ,rlg
order by pts desc,gd desc,gf desc;
