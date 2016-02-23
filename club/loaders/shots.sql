begin;

drop table if exists club.shots;

create table club.shots (
	game_id		      integer,
	id		      integer,
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
	part_player_id	      integer,
	part_jersey	      integer,
	part_start_x	      float,
	part_start_y	      float,
	part_player	      text,
	part_result	      text,
	part_result_text      text,
	primary key (game_id,id)
);

copy club.shots from '/tmp/shots.csv' csv;

commit;
