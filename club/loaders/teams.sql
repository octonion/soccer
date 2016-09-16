begin;

drop table if exists club.teams;

create table club.teams (
	year		      integer,
	league_id	      integer,
	league_key	      text,
	club_id		      integer,
	club_key	      text,
	club_name	      text,
	club_url	      text,
	primary key (year,league_id,club_id)
);

create temporary table c (
	year		      integer,
	league_id	      integer,
	league_key	      text,
	club_id		      integer,
	club_key	      text,
	club_name	      text,
	club_url	      text
);

copy c from '/tmp/teams.tsv' with delimiter as E'\t' csv;

insert into club.teams
(year,league_id,league_key,club_id,club_key,club_name,club_url)
(
select
distinct
year,league_id,league_key,club_id,club_key,club_name,club_url
from c
);

commit;
