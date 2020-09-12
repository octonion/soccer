begin;

drop table if exists epl.games;

set datestyle to 'SQL, DMY';

create table epl.games (
	round			text,
	date			timestamp,
	location		text,
	home_team		text,
	away_team		text,
	result			text,
	home_score		integer,
	away_score		integer
);

copy epl.games from '/tmp/games.csv' with delimiter as ',' csv;

alter table epl.games add column game_id serial;

update epl.games
set home_score = split_part(result,' - ',1)::integer,
    away_score = split_part(result,' - ',2)::integer;

commit;
