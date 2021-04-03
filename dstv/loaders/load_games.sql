begin;

drop table if exists dstv.games;

set datestyle to 'SQL, DMY';

create table dstv.games (
	season			integer,
	date			timestamp,
	home_team		text,
	away_team		text,
	home_score		integer,
	away_score		integer,
	halftime_score		text
);

copy dstv.games from '/tmp/games.csv' with delimiter as ',' csv;

alter table dstv.games add column game_id serial;

commit;
