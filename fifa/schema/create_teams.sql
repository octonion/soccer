begin;

drop table if exists fifa.teams;

create table fifa.teams (
	gender_id	      text,
	team_id		      text,
	team_name	      text,
	primary key (gender_id, team_id)
);

insert into fifa.teams
(gender_id,team_id,team_name)
(
select
gender_id,
home_id as team_id,
(case when home_id='civ' then E'Cote d\'Ivoire'
      else unaccent(home_name) end) as team_name
from fifa.games
where length(home_id)=3
and year>=2008

union

select
gender_id,
away_id as team_id,
(case when away_id='civ' then E'Cote d\'Ivoire'
      else unaccent(away_name) end) as team_name
from fifa.games
where length(away_id)=3
and year>=2008
);

commit;
