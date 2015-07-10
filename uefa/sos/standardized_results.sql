begin;

drop table if exists uefa.results;

create table uefa.results (
	game_id		      integer,
	game_date	      date,
	year		      integer,
	team_name	      text,
	team_id		      text,
	opponent_name	      text,
	opponent_id	      text,
	location_name	      text,
	location_id	      text,
	field		      text,
	team_score	      integer,
	opponent_score	      integer,
	game_length	      text
--	referee_name	      text
);

insert into uefa.results
(game_id,game_date,year,
 team_name,team_id,
 opponent_name,opponent_id,
 location_name,location_id,field,
 team_score,opponent_score,
 game_length)
-- referee_name)
(
select
g.game_id,
g.game_date,
g.year,
g.home_name,
g.home_name,
g.away_name,
g.away_name,
g.home_name as location_name,
g.home_name as location_id,
'offense_home' as field,
g.fthg as team_score,
g.ftag as opponent_score,
'0 OT' as game_length
--g.referee_name
from uefa.games g
where
    g.fthg is not null
and g.ftag is not null
and g.fthg >= 0
and g.ftag >= 0
and g.home_name is not null
and g.away_name is not null
and g.game_date is not null
--and year between 2013 and 2015
);

insert into uefa.results
(game_id,game_date,year,
 team_name,team_id,
 opponent_name,opponent_id,
 location_name,location_id,field,
 team_score,opponent_score,
 game_length)
-- referee_name)
(
select
g.game_id,
g.game_date,
g.year,
g.away_name,
g.away_name,
g.home_name,
g.home_name,
g.home_name as location_name,
g.home_name as location_id,
'defense_home' as field,
g.ftag as team_score,
g.fthg as opponent_score,
'0 OT' as game_length
--g.referee_name
from uefa.games g
where
    g.fthg is not null
and g.ftag is not null
and g.fthg >= 0
and g.ftag >= 0
and g.home_name is not null
and g.away_name is not null
and g.game_date is not null
--and g.year between 2013 and 2015
);

commit;
