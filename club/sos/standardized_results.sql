begin;

drop table if exists club.results;

create table club.results (
	game_id		      integer,
	game_date	      date,
	year		      integer,
	competition	      text,
	team_name	      text,
	team_id		      integer,
	opponent_name	      text,
	opponent_id	      integer,
	opponent_div_id	      integer,
	location_name	      text,
	location_id	      integer,
	field		      text,
	team_score	      integer,
	opponent_score	      integer
);

insert into club.results
(
game_id,game_date,year,
competition,
team_name,team_id,
opponent_name,opponent_id,
location_name,location_id,
field,
team_score,opponent_score)
(
select
game_id,
date::date,
g.year,
g.competition,
g.home_team_name,
g.home_team_id,
g.away_team_name,
g.away_team_id,
g.home_team_name as location_name,
g.home_team_id as location_id,
'offense_home' as field,
g.home_goals,
g.away_goals
from club.games g
where
    g.home_goals is not NULL
and g.away_goals is not NULL
and g.home_team_id is not NULL
and g.away_team_id is not NULL
and g.year=2016
and g.league_key = 'english+premier+league'
and g.club_id=g.home_team_id
and g.competition='Prem'

union all

select
game_id,
date::date,
g.year,
g.competition,
g.away_team_name,
g.away_team_id,
g.home_team_name,
g.home_team_id,
g.home_team_name as location_name,
g.home_team_id as location_id,
'defense_home' as field,
g.away_goals,
g.home_goals
from club.games g
where
    g.home_goals is not NULL
and g.away_goals is not NULL
and g.home_team_id is not NULL
and g.away_team_id is not NULL
and g.year=2016
and g.league_key = 'english+premier+league'
and g.club_id=g.home_team_id
and g.competition='Prem'

);

commit;
