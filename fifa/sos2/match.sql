begin;

create temporary table m (
       team_id	       text,
       opponent_id     text,
       intercept       float,
       team_o	       float,
       team_d	       float,
       opponent_o      float,
       opponent_d      float
);

insert into m
(team_id,opponent_id)
(select 'usa','swe');

update m
set intercept=estimate
from fifa._factors
where factor='(Intercept)';

update m
set team=estimate
from fifa.factors
where factor='(Intercept)';

