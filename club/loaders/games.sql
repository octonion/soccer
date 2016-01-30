begin;

drop table if exists club.games;

create table club.games (
	league_id	      integer,
	league_key	      text,
	club_id		      integer,
	club_key	      text,
	club_name	      text,
	club_url	      text,
	game_id		      integer,
	game_url	      text,
	date		      text,
	date_headline	      text,
	status		      text,
	league		      text,
	home_logo_src	      text,
	home_logo_alt	      text,
	home_team_id	      text,
	home_team_name	      text,
	home_score	      text,
	home_goals	      integer,
	home_pk		      integer,
	away_score	      text,
	away_goals	      integer,
	away_pk		      integer,
	away_logo_src	      text,
	away_logo_alt	      text,
	away_team_id	      text,
	away_team_name	      text,
	competition	      text,
	title		      text,
	primary key (club_id,game_id)
);

--copy club.games from '/tmp/games.tsv' with delimiter as E'\t' csv;

create temporary table g (
	league_id	      integer,
	league_key	      text,
	club_id		      integer,
	club_key	      text,
	club_name	      text,
	club_url	      text,
	game_id		      integer,
	game_url	      text,
	date		      text,
	date_headline	      text,
	status		      text,
	league		      text,
	home_logo_src	      text,
	home_logo_alt	      text,
	home_team_id	      text,
	home_team_name	      text,
	home_score	      text,
	home_goals	      integer,
	home_pk		      integer,
	away_score	      text,
	away_goals	      integer,
	away_pk		      integer,
	away_logo_src	      text,
	away_logo_alt	      text,
	away_team_id	      text,
	away_team_name	      text,
	competition	      text,
	title		      text
);

copy g from '/tmp/games.tsv' with delimiter as E'\t' csv;

insert into club.games
(
select
distinct
*
from g
);

commit;
