begin;

drop table if exists ncaa.results;

create table ncaa.results (
	game_id		      integer,
	game_date	      date,
	year		      integer,
	school_name	      text,
	school_id		      integer,
	school_div_id	      integer,
	opponent_name	      text,
	opponent_id	      integer,
	opponent_div_id	      integer,
	location_name	      text,
	location_id		      integer,
	field		      text,
	team_score	      integer,
	opponent_score	      integer
);

insert into ncaa.results
(game_id,game_date,year,
 school_name,school_id,
 opponent_name,opponent_id,
 location_name,location_id,field,
 team_score,opponent_score)
(
select
game_id,
(case when game_date='' then NULL
      else game_date::date end),
year,
trim(both from school_name),
school_id,
trim(both from opponent_name),
opponent_id,
 (case when location='Home' then trim(both from school_name)
       when location='Away' then trim(both from opponent_name)
       when location='Neutral' then 'neutral' end) as location_name,
 (case when location='Home' then school_id
       when location='Away' then opponent_id
       when location='Neutral' then 0 end) as location_id,
 (case when location='Home' then 'offense_home'
       when location='Away' then 'defense_home'
       when location='Neutral' then 'none' end) as field,
 g.team_score,
 g.opponent_score
 from ncaa.games g
 where
     g.location in ('Away','Home','Neutral')
 and g.team_score is not NULL
 and g.opponent_score is not NULL
 and g.team_score >= 0
 and g.opponent_score >= 0
-- and not((g.team_score,g.opponent_score)=(0,0))
 and g.school_id is not NULL
 and g.opponent_id is not NULL
 and not(g.game_date is null)
 and not(g.game_date='')
 and extract(year from g.game_date::date)=g.year-1
);

insert into ncaa.results
(game_id,game_date,year,
 school_name,school_id,
 opponent_name,opponent_id,
 location_name,location_id,field,
 team_score,opponent_score)
(select
 game_id,
 (case when game_date='' then NULL
       else game_date::date end),
 year,
 trim(both from opponent_name),
opponent_id,
 trim(both from school_name),
school_id,
 (case when location='Home' then trim(both from school_name)
       when location='Away' then trim(both from opponent_name)
       when location='Neutral' then 'neutral' end) as location_name,
 (case when location='Home' then school_id
       when location='Away' then opponent_id
       when location='Neutral' then 0 end) as location_id,
 (case when location='Home' then 'defense_home'
       when location='Away' then 'offense_home'
       when location='Neutral' then 'none' end) as field,
 g.opponent_score,
 g.team_score
 from ncaa.games g
 where
     g.location in ('Away','Home','Neutral')
 and g.team_score is not NULL
 and g.opponent_score is not NULL
 and g.team_score >= 0
 and g.opponent_score >= 0
-- and not((g.team_score,g.opponent_score)=(0,0))
 and g.school_id is not NULL
 and g.opponent_id is not NULL
 and not(g.game_date is null)
 and not(g.game_date='')
 and extract(year from g.game_date::date)=g.year-1
);

update ncaa.results
set school_div_id=sd.div_id
from ncaa.schools_divisions sd
where (sd.school_id,sd.year)=(results.school_id,results.year);

update ncaa.results
set opponent_div_id=sd.div_id
from ncaa.schools_divisions sd
where (sd.school_id,sd.year)=(results.opponent_id,results.year);

commit;
