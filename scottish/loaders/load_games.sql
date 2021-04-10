begin;

drop table if exists scottish.games;

set datestyle to 'SQL, YMD';

create table scottish.games (
	round			text,
	wk			text,
	day			text,
	date			date,
	time			text,
	home_team		text,
	score			text,
	away_team		text,
	attendance		text,
	venue			text,
	referee			text,
	match_report		text,
	notes			text,
	home_score		integer,
	away_score		integer
);

copy scottish.games from '/tmp/games.csv' with delimiter as ',' csv;

alter table scottish.games add column game_id serial;
--alter table scottish.games add column home_score integer;
--alter table scottish.games add column away_score integer;

update scottish.games
set home_score = split_part(score,'-',1)::integer,
    away_score = split_part(score,'-',2)::integer;

commit;
