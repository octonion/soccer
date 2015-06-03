begin;

create table ncaa.statistics (
        school_name             		text,
        school_id				integer,
	year		      		integer,
        player_name	      		text,
        player_id	      		integer,
	class_year	      		text,
	season		      		text,
	position	      		text,
	height		      		text,
	games				integer,
	field_goals	      		integer,
	field_goal_attempts   		integer,
	field_goal_percent    		float,
	three_pointers	      		integer,
	three_pointer_attempts	      	integer,
	three_pointer_percent		float,
	free_throws			integer,
	free_throw_attempts		integer,
	free_throw_percent		float,
	rebounds			integer,
	rebounds_per_game		float,
	assists				integer,
	assists_per_game		float,
	blocks				integer,
	blocks_per_game			float,
	steals				integer,
	steals_per_game			float,
	points				integer,
	points_per_game			float,
	turnovers			integer
);

copy ncaa.statistics from '/tmp/ncaa_statistics.csv' with delimiter as ',' csv header quote as '"';

commit;
