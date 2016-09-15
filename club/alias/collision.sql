select
game_team_name,count(*) as n
from (
select distinct game_club_name,game_team_name
from club.alias_teams
where game_club_name<>game_team_name
order by game_club_name) d
group by game_team_name
having count(*)>1
order by n desc;
