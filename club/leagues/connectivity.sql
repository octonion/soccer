select
r.year,
tl.league_name as team,
ol.league_name as opponent,
sum(
case when team_score>opponent_score then 1
     else 0
end) as w,
sum(
case when team_score=opponent_score then 1
     else 0
end) as d,
sum(
case when team_score<opponent_score then 1
     else 0
end) as l,
count(*) as n
from club.results r
join club.leagues tl
  on (tl.league_key)=(r.team_league_key)
join club.leagues ol
  on (ol.league_key)=(r.opponent_league_key)
group by r.year,team,opponent
order by r.year,team,opponent;

copy (
select
r.year,
tl.league_name as team,
ol.league_name as opponent,
sum(
case when team_score>opponent_score then 1
     else 0
end) as w,
sum(
case when team_score=opponent_score then 1
     else 0
end) as d,
sum(
case when team_score<opponent_score then 1
     else 0
end) as l,
count(*) as n
from club.results r
join club.leagues tl
  on (tl.league_key)=(r.team_league_key)
join club.leagues ol
  on (ol.league_key)=(r.opponent_league_key)
group by r.year,team,opponent
order by r.year,team,opponent
) to '/tmp/connectivity.csv' csv header;

