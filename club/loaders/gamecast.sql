begin;

create temporary table gc (
	game_id		      integer,
	year		      integer,
	league_key	      text,
	home_id		      integer,
	home_color	      text,
	home_name	      text,
	away_id		      integer,
	away_color	      text,
	away_name	      text
);

copy gc from '/tmp/gamecast.csv' csv;

delete from gc
where (game_id,league_key) in
(
select game_id,league_key
from gc
group by game_id,league_key
having count(*)>1
)
and year=2017;

drop table if exists club.gamecast;

create table club.gamecast (
	game_id		      integer,
	year		      integer,
	league_key	      text,
	home_id		      integer,
	home_color	      text,
	home_name	      text,
	away_id		      integer,
	away_color	      text,
	away_name	      text,
	primary key (game_id, league_key)
);

insert into club.gamecast
(
select
distinct
game_id,year,league_key,
home_id,home_color,home_name,
away_id,away_color,away_name
from gc
);

commit;
