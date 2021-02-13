begin;

drop table if exists aleague.games;

set datestyle to 'SQL, DMY';

create table aleague.games (
	round			text,
	date			timestamp,
	location		text,
	home_team		text,
	away_team		text,
	result			text,
	home_score		integer,
	away_score		integer
);

copy aleague.games from '/tmp/games.csv' with delimiter as ',' csv;

alter table aleague.games add column game_id serial;

update aleague.games
set home_score = split_part(result,' - ',1)::integer,
    away_score = split_part(result,' - ',2)::integer;

commit;
