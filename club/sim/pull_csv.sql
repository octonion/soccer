begin;

-- Remaining games

copy (
select
t.club_name,
o.club_name,

skellam(tf.exp_factor*sft.offensive,of.exp_factor*sfo.offensive,'win') as win,
skellam(tf.exp_factor*sft.offensive,of.exp_factor*sfo.offensive,'draw') as draw,
skellam(tf.exp_factor*sft.offensive,of.exp_factor*sfo.offensive,'lose') as lose

from club.games g
join club.teams t
  on (t.club_id,t.year)=(g.home_team_id,g.year)
join club._schedule_factors sft
  on (sft.team_id,sft.year)=(g.home_team_id,g.year)
join club.teams o
  on (o.club_id,o.year)=(g.away_team_id,g.year)
join club._schedule_factors sfo
  on (sfo.team_id,sfo.year)=(g.away_team_id,g.year)
join club._factors tf on
  tf.level='offense_home'
join club._factors of on
  of.level='defense_home'
where
    not(g.date='LIVE')
and g.league_key = 'english+premier+league'
and g.competition='Prem'
and g.date::date >= current_date
and g.home_goals is null
and g.away_goals is null
and g.club_id=g.home_team_id
order by g.club_name asc,g.date::date asc
) to '/tmp/games.csv' csv header;

-- Table

copy (
select
g.club_name as team,
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
end) as l

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
order by g.club_name asc

) to '/tmp/table.csv' csv header;

commit;
