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
from fifa.women_schedule_factors s1
join fifa.women_schedule_factors s2
  on (s1.team_id<>s2.team_id)
join fifa.teams t1
  on (t1.team_id,t1.gender_id)=(s1.team_id,'women')
join fifa.teams t2
  on (t2.team_id,t2.gender_id)=(s2.team_id,'women')
and s1.team_id in
  ('can', 'chn', 'kor', 'jpn', 'tha', 'sui', 'eng', 'nor', 'ger', 'esp',
   'fra', 'bra', 'col', 'cmr', 'crc', 'civ', 'mex', 'nzl', 'ned', 'ecu',
   'usa','swe', 'aus', 'nga')
and s2.team_id in
  ('can', 'chn', 'kor', 'jpn', 'tha', 'sui', 'eng', 'nor', 'ger', 'esp',
   'fra', 'bra', 'col', 'cmr', 'crc', 'civ', 'mex', 'nzl', 'ned', 'ecu',
   'usa','swe', 'aus', 'nga')
);

update m
set intercept=estimate
from fifa.women_basic_factors
where factor='(Intercept)';

update m
set team_o=raw_factor
from fifa.women_factors f
where f.parameter='offense'
and f.level=m.team_id;

update m
set team_d=raw_factor
from fifa.women_factors f
where f.parameter='defense'
and f.level=m.team_id;

update m
set opponent_o=raw_factor
from fifa.women_factors f
where f.parameter='offense'
and f.level=m.opponent_id;

update m
set opponent_d=raw_factor
from fifa.women_factors f
where f.parameter='defense'
and f.level=m.opponent_id;

update m
set team_o = team_o+0.101532950536216
where team_id='can';

update m
set team_d = team_d-0.133909716359734
where team_id='can';

update m
set opponent_o = opponent_o+0.101532950536216
where opponent_id='can';

update m
set opponent_d = opponent_d-0.133909716359734
where opponent_id='can';

update m
set team_mu = exp(intercept+team_o+opponent_d);

update m
set opponent_mu = exp(intercept+team_d+opponent_o);

select
team_name,
team_mu::numeric(4,1) as e_goals,
opponent_name,
opponent_mu::numeric(4,1) as e_goals,
skellam(team_mu,opponent_mu,'win')::numeric(4,3) as win,
skellam(team_mu,opponent_mu,'lose')::numeric(4,3) as lose,
skellam(team_mu,opponent_mu,'tie')::numeric(4,3) as tie
from m
order by team_name,opponent_name;

copy (
select
team_name,
team_mu::numeric(4,1) as e_goals,
opponent_name,
opponent_mu::numeric(4,1) as e_goals,
skellam(team_mu,opponent_mu,'win')::numeric(4,3) as win,
skellam(team_mu,opponent_mu,'lose')::numeric(4,3) as lose,
skellam(team_mu,opponent_mu,'tie')::numeric(4,3) as tie
from m
order by team_name,opponent_name
) to '/tmp/matchups_women.csv' csv header;

commit;
