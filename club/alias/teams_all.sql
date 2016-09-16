begin;

drop table if exists club.alias_all;

create table club.alias_all (
       game_club_id	      integer,
       game_team_name	      text
);

insert into club.alias_all
(
game_club_id,
game_team_name)
(
select
distinct
game_club_id,
game_team_name
from club.alias_teams
where game_team_name not in
(select game_team_name
from
(
select distinct game_club_id,game_team_name
from club.alias_teams
) d
group by game_team_name
having count(*)>1
)
);

commit;

