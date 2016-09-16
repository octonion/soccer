begin;

drop table if exists club.alias_teams;

create table club.alias_teams (
       year		      integer,
       league_key	      text,
       game_club_name	      text,
       game_club_id	      integer,
       game_team_name	      text,
       game_team_id	      integer,
       gamecast_team_name     text,
       gamecast_team_id	      integer
);

insert into club.alias_teams
(year,league_key,
game_club_name,game_club_id,
game_team_name,game_team_id,
gamecast_team_name,gamecast_team_id)
(
select
distinct
g.year,
g.league_key,
g.club_name,
g.club_id,
g.home_team_name,
g.home_team_id,
gc.home_name,
gc.home_id
from club.games g
join club.gamecast gc
  on (gc.game_id,gc.league_key)=(g.game_id,g.league_key)
where
--    g.club_id=g.home_team_id
g.club_id=gc.home_id
--and g.year=2015
--and g.league_key='english+league+two'
--order by g.home_team_name
);

commit;

