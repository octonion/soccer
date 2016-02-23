begin;

drop table if exists club.shots;

create table club.shots (
	game_id		      integer,
	shot_id		      integer,
	clock		      integer,
	added_time	      text,
	period		      text,
	start_x		      float,
	start_y		      float,
	team_id		      integer,
	goal		      boolean,
	own_goal	      boolean,
	shootout	      boolean,
	video_id	      integer,
	player		      text,
	result		      text,
	top_score_text	      text,
	shot_by_text	      text,
	parts		      integer,
	primary key (game_id,shot_id)
);

copy club.shots from '/tmp/shots.csv' csv;

commit;
