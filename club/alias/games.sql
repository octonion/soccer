update club.games
set home_team_id=game_club_id
from club.alias_all
where home_team_name = game_team_name;

update club.games
set away_team_id=game_club_id
from club.alias_all
where away_team_name = game_team_name;
