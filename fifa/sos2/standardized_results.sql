begin;

drop table if exists fifa.results;

create table fifa.results (
	game_id		      integer,
	gender_id	      text,
	year		      integer,
	team_name	      text,
	team_id		      text,
	opponent_name	      text,
	opponent_id	      text,
	location_name	      text,
	field		      text,
	team_score	      integer,
	opponent_score	      integer,
	game_length	      text
);

insert into fifa.results
(game_id,gender_id,year,
 team_name,team_id,
 opponent_name,opponent_id,
 location_name,field,
 team_score,opponent_score,game_length)
(
select
g.game_id,
g.gender_id,
g.year,
g.home_name,
g.home_id,
g.away_name,
g.away_id,
venue,
(case when venue ~ home_name then 'offense_home'
      else 'neutral' end) as field,
g.home_score,
g.away_score,
(case when g.after_extra_time then '1 OT'
      else '0 OT' end) as game_length
from fifa.games g
where
    g.home_score is not NULL
and g.away_score is not NULL

and g.home_id is not NULL
and g.away_id is not NULL

and g.cup_name not like '%U-17%'
and g.cup_name not like '%U-20%'
and g.cup_name not like '%Beach%'
and g.cup_name not like '%Youth%'
and g.cup_name not like '%Futsal%'

and g.gender_id='women'
);

insert into fifa.results
(game_id,gender_id,year,
 team_name,team_id,
 opponent_name,opponent_id,
 location_name,field,
 team_score,opponent_score,game_length)
(
select
g.game_id,
g.gender_id,
g.year,
g.away_name,
g.away_id,
g.home_name,
g.home_id,
venue,
(case when venue ~ home_name then 'defense_home'
      else 'neutral' end) as field,
g.away_score,
g.home_score,
(case when g.after_extra_time then '1 OT'
      else '0 OT' end) as game_length
from fifa.games g
where
    g.home_score is not NULL
and g.away_score is not NULL

and g.home_id is not NULL
and g.away_id is not NULL

and g.cup_name not like '%U-17%'
and g.cup_name not like '%U-20%'
and g.cup_name not like '%Beach%'
and g.cup_name not like '%Youth%'
and g.cup_name not like '%Futsal%'

and g.gender_id='women'
);

update fifa.results
set team_id=t.team_id
from fifa.teams t
where (results.team_name)=(t.team_name)
and length(results.team_id)>3;

update fifa.results
set opponent_id=t.team_id
from fifa.teams t
where (results.opponent_name)=(t.team_name)
and length(results.opponent_id)>3;

update fifa.results
set team_id='eng'
where team_name='Great Britain';

commit;
