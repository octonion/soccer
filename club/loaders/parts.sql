begin;

drop table if exists club.parts;

create table club.parts (
	game_id		      integer,
	year		      integer,
	league_key	      text,
	shot_id		      integer,
	part_id		      integer,
	player_id	      integer,
	jersey	      	      integer,
	start_x	      	      float,
	start_y	      	      float,
	end_x		      float,
	end_y		      float,
	end_z		      float,
	player	      	      text,
	result	      	      text,
	result_text           text,
	primary key (game_id,league_key,shot_id,part_id)
);

copy club.parts from '/tmp/parts.csv' csv;

commit;
