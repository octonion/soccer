begin;

drop table if exists eflc.games;

set datestyle to 'SQL, YMD';

create table eflc.games (
	season			integer,
	round			text,
	week			text,
	day			text,
	date			date,
	time			text,
	home_team		text,
	score			text,
	away_team		text,
	attendance		integer,
	venue			text,
	referee			text,
	match_report		text,
	notes			text,
	home_score		integer,
	away_score		integer
);

copy eflc.games from '/tmp/games.csv' with delimiter as ',' csv;

alter table eflc.games add column game_id serial;

update eflc.games
set home_score = split_part(score,'–',1)::integer,
    away_score = split_part(score,'–',2)::integer;

commit;
