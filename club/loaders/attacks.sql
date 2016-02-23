begin;

drop table if exists club.attacks;

create table club.attacks (
	game_id		      integer,
	year		      integer,
	league_key	      text,
	key		      text,
	jersey		      integer,
	avg_x		      float,
	avg_y		      float,
	pos_x		      float,
	pos_y		      float,
	"left"		      float,
	middle		      float,
	"right"		      float,
	player_id	      integer,
	team_id		      integer,
	position	      text,
	cdata		      text,
	heat_map	      integer[][]
--	primary key (game_id, key)
	
);

copy club.attacks from '/tmp/attacks.csv' csv;

commit;
