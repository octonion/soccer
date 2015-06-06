begin;

create temporary table m (
       team_id	       text,
       team_name       text,
       opponent_id     text,
       opponent_name   text,
       intercept       float,
       team_o	       float,
       team_d	       float,
       opponent_o      float,
       opponent_d      float,
       team_mu	       float,
       opponent_mu     float
);

insert into m
(team_id,team_name,opponent_id,opponent_name)
(
select s1.team_id,t1.team_name,s2.team_id,t2.team_name
from fifa._schedule_factors s1
join fifa._schedule_factors s2
  on (s1.team_id<>s2.team_id)
join fifa.teams t1
  on (t1.team_id,t1.gender_id)=(s1.team_id,'women')
join fifa.teams t2
  on (t2.team_id,t2.gender_id)=(s2.team_id,'women')
and s1.team_id in
  ('can', 'chn', 'kor', 'jpn', 'tha', 'sui', 'eng', 'nor', 'ger', 'esp',
   'fra', 'bra', 'col', 'cmr', 'crc', 'civ', 'mex', 'nzl', 'ned', 'ecu',
   'usa',' swe', 'aus', 'nga')
and s2.team_id in
  ('can', 'chn', 'kor', 'jpn', 'tha', 'sui', 'eng', 'nor', 'ger', 'esp',
   'fra', 'bra', 'col', 'cmr', 'crc', 'civ', 'mex', 'nzl', 'ned', 'ecu',
   'usa',' swe', 'aus', 'nga')
);

update m
set intercept=estimate
from fifa._basic_factors
where factor='(Intercept)';

update m
set team_o=raw_factor
from fifa._factors f
where f.parameter='offense'
and f.level=m.team_id;

update m
set team_d=raw_factor
from fifa._factors f
where f.parameter='defense'
and f.level=m.team_id;

update m
set opponent_o=raw_factor
from fifa._factors f
where f.parameter='offense'
and f.level=m.opponent_id;

update m
set opponent_d=raw_factor
from fifa._factors f
where f.parameter='defense'
and f.level=m.opponent_id;

update m
set team_mu = exp(intercept+team_o+opponent_d);

update m
set opponent_mu = exp(intercept+team_d+opponent_o);

select
team_name,
opponent_name,
skellam(team_mu,opponent_mu,'win')::numeric(4,3) as win,
skellam(team_mu,opponent_mu,'lose')::numeric(4,3) as lose,
skellam(team_mu,opponent_mu,'tie')::numeric(4,3) as tie
from m
order by team_name,opponent_name;

copy (
select
team_name,
opponent_name,
skellam(team_mu,opponent_mu,'win')::numeric(4,3) as win,
skellam(team_mu,opponent_mu,'lose')::numeric(4,3) as lose,
skellam(team_mu,opponent_mu,'tie')::numeric(4,3) as tie
from m
order by team_name,opponent_name
) to '/tmp/matchups.csv' csv header;

commit;
