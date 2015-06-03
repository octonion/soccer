begin;

drop table if exists ncaa.results;

create table ncaa.results (
	game_id		      integer,
	game_date	      date,
	year		      integer,
	school_name	      text,
	school_id	      integer,
	team_div_id	      integer,
	opponent_name	      text,
	opponent_id	      integer,
	opponent_div_id	      integer,
	location_name	      text,
	location_id	      integer,
	field		      text,
	team_score	      integer,
	opponent_score	      integer,
	game_length	      text
);

/*
create temporary table c (
	year		      integer,
	school_id	      integer,
	n		      integer
);

insert into c
(year,school_id,n)
(
select year,school_id,sum(n)
 from (
 select year,school_id,count(*) as n
 from ncaa.games
 group by year,school_id
 union
 select year,opponent_id,count(*)
 from ncaa.games
 group by year,opponent_id) as s
group by year,school_id
);
*/

--select * from c;

insert into ncaa.results
(game_id,game_date,year,
 school_name,school_id,
 opponent_name,opponent_id,
 location_name,location_id,field,
 team_score,opponent_score,game_length)
(
select
game_id,
(case when game_date='' then NULL
      else game_date::date end),
g.year,
trim(both from g.school_name),
g.school_id,
trim(both from g.opponent_name),
g.opponent_id,
 (case when location='Home' then trim(both from school_name)
       when location='Away' then trim(both from opponent_name)
       when location='Neutral' then 'neutral' end) as location_name,
 (case when location='Home' then g.school_id
       when location='Away' then g.opponent_id
       when location='Neutral' then 0 end) as location_id,
 (case when location='Home' then 'offense_home'
       when location='Away' then 'defense_home'
       when location='Neutral' then 'none' end) as field,
g.team_score,
g.opponent_score,
(case when g.game_length='' then '0 OT'
      else g.game_length end) as game_length
from ncaa.games g
-- join c as c1 on (c1.school_id,c1.year)=(g.school_id,g.year)
-- join c as c2 on (c2.school_id,c2.year)=(g.opponent_id,g.year)
where
    g.location in ('Away','Home','Neutral')
and g.team_score is not NULL
and g.opponent_score is not NULL
and g.team_score >= 0
and g.opponent_score >= 0
--and not((g.team_score,g.opponent_score)=(0,0))
--and (not((g.team_score,g.opponent_score)=(0,0)) or
--     (g.team_score,g.opponent_score)=(0,0) and (g.game_length like '%OT%'))
and g.school_id is not NULL
and g.opponent_id is not NULL
and not(g.game_date is null)
and g.year between 2012 and 2014
-- and c1.n >=20
-- and c2.n >=20
);

insert into ncaa.results
(game_id,game_date,year,
 school_name,school_id,
 opponent_name,opponent_id,
 location_name,location_id,field,
 team_score,opponent_score,game_length)
(
select
g.game_id,
(case when game_date='' then NULL
      else game_date::date end),
g.year,
trim(both from g.opponent_name),
g.opponent_id,
trim(both from g.school_name),
g.school_id,
 (case when location='Home' then trim(both from school_name)
       when location='Away' then trim(both from opponent_name)
       when location='Neutral' then 'neutral' end) as location_name,
 (case when location='Home' then g.school_id
       when location='Away' then g.opponent_id
       when location='Neutral' then 0 end) as location_id,
 (case when location='Home' then 'defense_home'
       when location='Away' then 'offense_home'
       when location='Neutral' then 'none' end) as field,
g.opponent_score,
g.team_score,
(case when g.game_length='' then '0 OT'
      else g.game_length end) as game_length
from ncaa.games g
where
    g.location in ('Away','Home','Neutral')
and g.team_score is not NULL
and g.opponent_score is not NULL
and g.team_score >= 0
and g.opponent_score >= 0
--and not((g.team_score,g.opponent_score)=(0,0))
--and (not((g.team_score,g.opponent_score)=(0,0)) or
--     (g.team_score,g.opponent_score)=(0,0) and (g.game_length like '%OT%'))
and g.school_id is not NULL
and g.opponent_id is not NULL
and not(g.game_date is null)
and g.year between 2012 and 2014
);

update ncaa.results
set team_div_id=sd.div_id
from ncaa.schools_divisions sd
where (sd.school_id,sd.year)=(results.school_id,results.year);

update ncaa.results
set opponent_div_id=sd.div_id
from ncaa.schools_divisions sd
where (sd.school_id,sd.year)=(results.opponent_id,results.year);

commit;
