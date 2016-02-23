begin;

drop table if exists club.gamecast;

create table club.gamecast (
	game_id		      integer,
	home_id		      integer,
	home_color	      text,
	home_name	      text,
	away_id		      integer,
	away_color	      text,
	away_name	      text,
	primary key (game_id)
);

copy club.gamecast from '/tmp/gamecast.csv' csv;

commit;
