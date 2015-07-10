begin;

set timezone to 'America/Los_Angeles';

select

g.year,
g.game_date::date as date,
hd.team_name as team,
hd.team_id,
hd.div_id as h_div,
--'home' as site,
vd.team_name as opp,
vd.team_id,
vd.div_id as v_div,

g.team_score as t_score,
g.opponent_score as o_score

from uefa.results g
join uefa.teams_divisions hd
  on (hd.year,hd.team_id)=(g.year,g.team_id)
join uefa.teams_divisions vd
  on (vd.year,vd.team_id)=(g.year,g.opponent_id)

where
TRUE
and g.year = 2011
--and g.team_id < g.opponent_id
--and hd.div_id=1
--and g.field='offense_home'

--and g.team_score>0
--and g.opponent_score>0

and hd.div_id < vd.div_id
and hd.div_id + vd.div_id = 4

union

select
g.year,
g.game_date::date as date,
hd.team_name as team,
g.team_id,
hd.div_id as h_div,
--'neutral' as site,
vd.team_name as opp,
vd.team_id,
vd.div_id as v_div,

g.team_score as t_score,
g.opponent_score as o_score

from uefa.results g
join uefa.teams_divisions hd
  on (hd.year,hd.team_id)=(g.year,g.team_id)
join uefa.teams_divisions vd
  on (vd.year,vd.team_id)=(g.year,g.opponent_id)

where
TRUE
and g.year = 2011
and g.field='none'

--and g.team_score>0
--and g.opponent_score>0

--and g.team_id < g.opponent_id
--and hd.div_id=1

and hd.div_id < vd.div_id
and hd.div_id + vd.div_id = 4

order by year,date,team asc;

commit;
