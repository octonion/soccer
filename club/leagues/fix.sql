begin;

update club.games
set home_team_id=club_id
where
--(club_name like split_part(home_team_name,' ',1)||'%')
club_name=home_logo_alt
and home_team_id is null;

update club.games
set away_team_id=club_id
where
--(club_name like split_part(home_team_name,' ',1)||'%')
club_name=away_logo_alt
and away_team_id is null;

update club.games
set home_team_id=a.home_team_id
from club.games a
where games.game_id=a.game_id
and games.home_team_id is null
and a.home_team_id is not null;

update club.games
set away_team_id=a.away_team_id
from club.games a
where games.game_id=a.game_id
and games.away_team_id is null
and a.away_team_id is not null;

commit;

--select distinct ((club_name like split_part(home_team_name,' ',1)||'%') or (club_name like split_part(away_team_name,' ',1)||'%')) as match,club_name,club_id,home_team_name,home_team_id,away_team_name,away_team_id from club.games where league_key='english+league+one' and year=2015 order by match;
