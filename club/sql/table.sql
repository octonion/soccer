select
year,
club_name,
--home_team_name,
--away_team_name,
--home_goals,
--home_pk,
--away_goals,
--away_pk,
(case when club_id=home_team_id
      and ((home_goals > away_goals)
           or (home_goals=away_goals and home_pk>away_pk)) then 'win'
      when club_id=away_team_id
      and ((home_goals < away_goals)
           or (home_goals=away_goals and home_pk<away_pk)) then 'win'
      when ((home_goals=away_goals) and
            ((home_pk is null and away_pk is null) or (home_pk=away_pk)))
	    then 'draw'
      else 'lose'
end) as result,
count(*) as n
from club.games
where
year=2015
and league_key = 'barclays+premier+league'
--and club_key = 'everton'
and home_goals is not null
and away_goals is not null
and competition = 'Prem'
group by year,club_name,result
order by year,club_name,result;
