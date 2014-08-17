begin;

set timezone to 'America/Los_Angeles';

select

g.year,
g.game_date::date as date,
hd.school_name as team,
hd.school_id,
hd.div_id as h_div,
--'home' as site,
vd.school_name as opp,
vd.school_id,
vd.div_id as v_div,

g.team_score as t_score,
g.opponent_score as o_score

from ncaa.results g
join ncaa.schools_divisions hd
  on (hd.year,hd.school_id)=(g.year,g.school_id)
join ncaa.schools_divisions vd
  on (vd.year,vd.school_id)=(g.year,g.opponent_id)

where
TRUE
and g.year = 2011
--and g.school_id < g.opponent_id
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
hd.school_name as team,
g.school_id,
hd.div_id as h_div,
--'neutral' as site,
vd.school_name as opp,
vd.school_id,
vd.div_id as v_div,

g.team_score as t_score,
g.opponent_score as o_score

from ncaa.results g
join ncaa.schools_divisions hd
  on (hd.year,hd.school_id)=(g.year,g.school_id)
join ncaa.schools_divisions vd
  on (vd.year,vd.school_id)=(g.year,g.opponent_id)

where
TRUE
and g.year = 2011
and g.field='none'

--and g.team_score>0
--and g.opponent_score>0

--and g.school_id < g.opponent_id
--and hd.div_id=1

and hd.div_id < vd.div_id
and hd.div_id + vd.div_id = 4

order by year,date,team asc;

commit;
