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
from fifa._basic_factors
where factor='(Intercept)';

update m
set team_o=estimate
from fifa._factors f
where f.factor='offense'
and f.level=m.team_id';

update m
set team_d=estimate
from fifa._factors f
where f.factor='defense'
and f.level=m.team_id';

update m
set opponent_o=estimate
from fifa._factors f
where f.factor='offense'
and f.level=m.opponent_id';

update m
set opponent_d=estimate
from fifa._factors f
where f.factor='defense'
and f.level=m.opponent_id';

select * from m;

commit;
