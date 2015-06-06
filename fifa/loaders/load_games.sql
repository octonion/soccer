begin;

drop table if exists fifa.games;

create table fifa.games (
	gender_id	      text,
	year		      integer,
	month		      integer,
	cup_name	      text,
	cupseason_id	      text,
	match_title	      text,
	match_subtitle	      text,
	match_date	      text,
	comp_group	      text,
	data_id		      integer,
	data_matchdate	      text,
	home_id		      text,
	home_name	      text,
	home_url	      text,
	away_id		      text,
	away_name	      text,
	away_url	      text,
	score		      text,
	venue		      text,
	primary key (gender_id,year,month,data_id)
);

copy fifa.games from '/tmp/games.csv' with delimiter as ',' csv quote as '"';

alter table fifa.games add column game_id serial;

alter table fifa.games add column home_score integer;
alter table fifa.games add column away_score integer;
alter table fifa.games add column after_extra_time boolean;
alter table fifa.games add column win_on_penalty boolean;
alter table fifa.games add column win_by_golden_goal boolean;
alter table fifa.games add column win_on_away_goals boolean;
alter table fifa.games add column aggregate boolean;

update fifa.games
set home_score = split_part(split_part(score,' ',1),'-',1)::integer,
    away_score = split_part(split_part(score,' ',1),'-',2)::integer,
    after_extra_time = (case when score like '% AET%' then TRUE
                        else FALSE end),
    win_on_penalty = (case when score like '% Win on penalty%' then TRUE
                      else FALSE end),
    win_by_golden_goal = (case when score like '% Win by Golden Goal%' then TRUE
                          else FALSE end),
    win_on_away_goals = (case when score like '% Win on away goals%' then TRUE
                         else FALSE end),
    aggregate = (case when score like '% Aggregate%' then TRUE
                 else FALSE end);

commit;
