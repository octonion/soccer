begin;

drop table if exists club.results;

create table club.results (
	game_id		      integer,
	game_date	      date,
	year		      integer,
	team_name	      text,
	team_id		      integer,
	team_league_key	      text,
	opponent_name	      text,
	opponent_id	      integer,
	opponent_league_key   text,
	location_name	      text,
	location_id	      integer,
	field		      text,
	team_score	      integer,
	opponent_score	      integer
);

insert into club.results
(
game_id,game_date,year,
team_name,team_id,team_league_key,
opponent_name,opponent_id,opponent_league_key,
location_name,location_id,
field,
team_score,opponent_score)
(
select
game_id,
date::date,
g.year,
g.home_team_name,
g.home_team_id,
t.league_key,
g.away_team_name,
g.away_team_id,
o.league_key,
g.home_team_name as location_name,
g.home_team_id as location_id,
'offense_home' as field,
abs(g.home_goals),
abs(g.away_goals)
from club.games g
join club.teams t
  on (t.year,t.club_id)=(g.year,g.home_team_id)
join club.teams o
  on (o.year,o.club_id)=(g.year,g.away_team_id)
where
    g.home_goals is not NULL
and g.away_goals is not NULL
and g.home_team_id is not NULL
and g.away_team_id is not NULL

and g.year>=2008

--and g.league_key = 'barclays+premier+league'
and g.club_id=g.home_team_id
--and g.competition='Prem'
and g.title not in ('Friendly')

and t.league_key=o.league_key

and t.league_key in
(
'austrian+bundesliga',
'barclays+premier+league',
'belgian+jupiler+league',
'danish+sas-ligaen',
'dutch+eredivisie',
'english+league+championship',
'english+league+one',
'english+league+two',
'french+ligue+1',
'french+ligue+2',
'fútbol+profesional+colombiano',
'futebol+brasileiro',
'german+2.+bundesliga',
'german+bundesliga',
'italian+serie+a',
'italian+serie+b',
'liga+profesional+boliviana',
'major+league+soccer',
'mexican+liga+mx',
'portuguese+liga',
'primera+a+de+ecuador',
'primera+división+de+argentina',
'primera+división+de+chile',
'primera+división+de+paraguay',
'primera+división+de+uruguay',
'primera+división+de+venezuela',
'primera+profesional+de+perú',
'russian+premier+league',
'spanish+primera+división',
'swedish+allsvenskanliga',
'swiss+super+league',
'turkish+super+lig',
'australian+a-league'
)

and o.league_key in
(
'austrian+bundesliga',
'barclays+premier+league',
'belgian+jupiler+league',
'danish+sas-ligaen',
'dutch+eredivisie',
'english+league+championship',
'english+league+one',
'english+league+two',
'french+ligue+1',
'french+ligue+2',
'fútbol+profesional+colombiano',
'futebol+brasileiro',
'german+2.+bundesliga',
'german+bundesliga',
'italian+serie+a',
'italian+serie+b',
'liga+profesional+boliviana',
'major+league+soccer',
'mexican+liga+mx',
'portuguese+liga',
'primera+a+de+ecuador',
'primera+división+de+argentina',
'primera+división+de+chile',
'primera+división+de+paraguay',
'primera+división+de+uruguay',
'primera+división+de+venezuela',
'primera+profesional+de+perú',
'russian+premier+league',
'spanish+primera+división',
'swedish+allsvenskanliga',
'swiss+super+league',
'turkish+super+lig',
'australian+a-league'
)

union all

select
game_id,
date::date,
g.year,
g.away_team_name,
g.away_team_id,
o.league_key,
g.home_team_name,
g.home_team_id,
t.league_key,
g.home_team_name as location_name,
g.home_team_id as location_id,
'defense_home' as field,
abs(g.away_goals),
abs(g.home_goals)
from club.games g
join club.teams t
  on (t.year,t.club_id)=(g.year,g.home_team_id)
join club.teams o
  on (o.year,o.club_id)=(g.year,g.away_team_id)
where
    g.home_goals is not NULL
and g.away_goals is not NULL
and g.home_team_id is not NULL
and g.away_team_id is not NULL

and g.year>=2008

--and g.league_key = 'barclays+premier+league'
and g.club_id=g.home_team_id
--and g.competition='Prem'
and g.title not in ('Friendly')

and t.league_key=o.league_key

and t.league_key in
(
'austrian+bundesliga',
'barclays+premier+league',
'belgian+jupiler+league',
'danish+sas-ligaen',
'dutch+eredivisie',
'english+league+championship',
'english+league+one',
'english+league+two',
'french+ligue+1',
'french+ligue+2',
'fútbol+profesional+colombiano',
'futebol+brasileiro',
'german+2.+bundesliga',
'german+bundesliga',
'italian+serie+a',
'italian+serie+b',
'liga+profesional+boliviana',
'major+league+soccer',
'mexican+liga+mx',
'portuguese+liga',
'primera+a+de+ecuador',
'primera+división+de+argentina',
'primera+división+de+chile',
'primera+división+de+paraguay',
'primera+división+de+uruguay',
'primera+división+de+venezuela',
'primera+profesional+de+perú',
'russian+premier+league',
'spanish+primera+división',
'swedish+allsvenskanliga',
'swiss+super+league',
'turkish+super+lig',
'australian+a-league'
)

and o.league_key in
(
'austrian+bundesliga',
'barclays+premier+league',
'belgian+jupiler+league',
'danish+sas-ligaen',
'dutch+eredivisie',
'english+league+championship',
'english+league+one',
'english+league+two',
'french+ligue+1',
'french+ligue+2',
'fútbol+profesional+colombiano',
'futebol+brasileiro',
'german+2.+bundesliga',
'german+bundesliga',
'italian+serie+a',
'italian+serie+b',
'liga+profesional+boliviana',
'major+league+soccer',
'mexican+liga+mx',
'portuguese+liga',
'primera+a+de+ecuador',
'primera+división+de+argentina',
'primera+división+de+chile',
'primera+división+de+paraguay',
'primera+división+de+uruguay',
'primera+división+de+venezuela',
'primera+profesional+de+perú',
'russian+premier+league',
'spanish+primera+división',
'swedish+allsvenskanliga',
'swiss+super+league',
'turkish+super+lig',
'australian+a-league'
)

);


insert into club.results
(
game_id,game_date,year,
team_name,team_id,team_league_key,
opponent_name,opponent_id,opponent_league_key,
location_name,location_id,
field,
team_score,opponent_score)
(
select
game_id,
date::date,
g.year,
g.home_team_name,
g.home_team_id,
t.league_key,
g.away_team_name,
g.away_team_id,
o.league_key,
g.home_team_name as location_name,
g.home_team_id as location_id,
'neutral' as field,
abs(g.home_goals),
abs(g.away_goals)
from club.games g
join club.teams t
  on (t.year,t.club_id)=(g.year,g.home_team_id)
join club.teams o
  on (o.year,o.club_id)=(g.year,g.away_team_id)
where
    g.home_goals is not NULL
and g.away_goals is not NULL
and g.home_team_id is not NULL
and g.away_team_id is not NULL

and g.year>=2008

--and g.league_key = 'barclays+premier+league'
and g.club_id=g.home_team_id
--and g.competition='Prem'
and g.title not in ('Friendly')

and not(t.league_key=o.league_key)

and t.league_key in
(
'austrian+bundesliga',
'barclays+premier+league',
'belgian+jupiler+league',
'danish+sas-ligaen',
'dutch+eredivisie',
'english+league+championship',
'english+league+one',
'english+league+two',
'french+ligue+1',
'french+ligue+2',
'fútbol+profesional+colombiano',
'futebol+brasileiro',
'german+2.+bundesliga',
'german+bundesliga',
'italian+serie+a',
'italian+serie+b',
'liga+profesional+boliviana',
'major+league+soccer',
'mexican+liga+mx',
'portuguese+liga',
'primera+a+de+ecuador',
'primera+división+de+argentina',
'primera+división+de+chile',
'primera+división+de+paraguay',
'primera+división+de+uruguay',
'primera+división+de+venezuela',
'primera+profesional+de+perú',
'russian+premier+league',
'spanish+primera+división',
'swedish+allsvenskanliga',
'swiss+super+league',
'turkish+super+lig',
'australian+a-league'
)

and o.league_key in
(
'austrian+bundesliga',
'barclays+premier+league',
'belgian+jupiler+league',
'danish+sas-ligaen',
'dutch+eredivisie',
'english+league+championship',
'english+league+one',
'english+league+two',
'french+ligue+1',
'french+ligue+2',
'fútbol+profesional+colombiano',
'futebol+brasileiro',
'german+2.+bundesliga',
'german+bundesliga',
'italian+serie+a',
'italian+serie+b',
'liga+profesional+boliviana',
'major+league+soccer',
'mexican+liga+mx',
'portuguese+liga',
'primera+a+de+ecuador',
'primera+división+de+argentina',
'primera+división+de+chile',
'primera+división+de+paraguay',
'primera+división+de+uruguay',
'primera+división+de+venezuela',
'primera+profesional+de+perú',
'russian+premier+league',
'spanish+primera+división',
'swedish+allsvenskanliga',
'swiss+super+league',
'turkish+super+lig',
'australian+a-league'
)

union all

select
game_id,
date::date,
g.year,
g.away_team_name,
g.away_team_id,
o.league_key,
g.home_team_name,
g.home_team_id,
t.league_key,
g.home_team_name as location_name,
g.home_team_id as location_id,
'neutral' as field,
abs(g.away_goals),
abs(g.home_goals)
from club.games g
join club.teams t
  on (t.year,t.club_id)=(g.year,g.home_team_id)
join club.teams o
  on (o.year,o.club_id)=(g.year,g.away_team_id)
where
    g.home_goals is not NULL
and g.away_goals is not NULL
and g.home_team_id is not NULL
and g.away_team_id is not NULL

and g.year>=2008

--and g.league_key = 'barclays+premier+league'
and g.club_id=g.home_team_id
--and g.competition='Prem'
and g.title not in ('Friendly')

and not(t.league_key=o.league_key)

and t.league_key in
(
'austrian+bundesliga',
'barclays+premier+league',
'belgian+jupiler+league',
'danish+sas-ligaen',
'dutch+eredivisie',
'english+league+championship',
'english+league+one',
'english+league+two',
'french+ligue+1',
'french+ligue+2',
'fútbol+profesional+colombiano',
'futebol+brasileiro',
'german+2.+bundesliga',
'german+bundesliga',
'italian+serie+a',
'italian+serie+b',
'liga+profesional+boliviana',
'major+league+soccer',
'mexican+liga+mx',
'portuguese+liga',
'primera+a+de+ecuador',
'primera+división+de+argentina',
'primera+división+de+chile',
'primera+división+de+paraguay',
'primera+división+de+uruguay',
'primera+división+de+venezuela',
'primera+profesional+de+perú',
'russian+premier+league',
'spanish+primera+división',
'swedish+allsvenskanliga',
'swiss+super+league',
'turkish+super+lig',
'australian+a-league'
)

and o.league_key in
(
'austrian+bundesliga',
'barclays+premier+league',
'belgian+jupiler+league',
'danish+sas-ligaen',
'dutch+eredivisie',
'english+league+championship',
'english+league+one',
'english+league+two',
'french+ligue+1',
'french+ligue+2',
'fútbol+profesional+colombiano',
'futebol+brasileiro',
'german+2.+bundesliga',
'german+bundesliga',
'italian+serie+a',
'italian+serie+b',
'liga+profesional+boliviana',
'major+league+soccer',
'mexican+liga+mx',
'portuguese+liga',
'primera+a+de+ecuador',
'primera+división+de+argentina',
'primera+división+de+chile',
'primera+división+de+paraguay',
'primera+división+de+uruguay',
'primera+división+de+venezuela',
'primera+profesional+de+perú',
'russian+premier+league',
'spanish+primera+división',
'swedish+allsvenskanliga',
'swiss+super+league',
'turkish+super+lig',
'australian+a-league'
)

);

commit;
