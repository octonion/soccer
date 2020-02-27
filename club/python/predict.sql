select
ts.date::date,
'home',

t.club_name,
exp(i.estimate)*y.exp_factor*tf.exp_factor*tol.exp_factor*sft.offensive*odl.exp_factor*sfo.defensive as teo,

o.club_name,
exp(i.estimate)*y.exp_factor*of.exp_factor*ool.exp_factor*sfo.offensive*tdl.exp_factor*sft.defensive as opo,

skellam(exp(i.estimate)*y.exp_factor*tf.exp_factor*tol.exp_factor*sft.offensive*odl.exp_factor*sfo.defensive,exp(i.estimate)*y.exp_factor*of.exp_factor*ool.exp_factor*sfo.offensive*tdl.exp_factor*sft.defensive,'win') as win,

skellam(exp(i.estimate)*y.exp_factor*tf.exp_factor*tol.exp_factor*sft.offensive*odl.exp_factor*sfo.defensive,exp(i.estimate)*y.exp_factor*of.exp_factor*ool.exp_factor*sfo.offensive*tdl.exp_factor*sft.defensive,'lose') as lose,

skellam(exp(i.estimate)*y.exp_factor*tf.exp_factor*tol.exp_factor*sft.offensive*odl.exp_factor*sfo.defensive,exp(i.estimate)*y.exp_factor*of.exp_factor*ool.exp_factor*sfo.offensive*tdl.exp_factor*sft.defensive,'draw') as draw

from club.games ts
join club.teams t
  on (t.club_id,t.year)=(ts.home_team_id,ts.year)
join club.leagues tl
  on (tl.league_key)=(t.league_key)
join club._schedule_factors sft
  on (sft.team_id,sft.year)=(ts.home_team_id,ts.year)
join club._factors tol
  on (tol.parameter,tol.level)=('offense_league',t.league_key)
join club._factors tdl
  on (tdl.parameter,tdl.level)=('defense_league',t.league_key)

join club.teams o
  on (o.club_id,o.year)=(ts.away_team_id,ts.year)
join club.leagues ol
  on (ol.league_key)=(o.league_key)
join club._schedule_factors sfo
  on (sfo.team_id,sfo.year)=(ts.away_team_id,ts.year)
join club._factors ool
  on (ool.parameter,ool.level)=('offense_league',o.league_key)
join club._factors odl
  on (odl.parameter,odl.level)=('defense_league',o.league_key)

join club._factors tf on
  tf.level='offense_home'
join club._factors of on
  of.level='defense_home'
join club._factors y on
  y.level='2019'

join club._basic_factors i on
  i.factor='(Intercept)'

where not(ts.date='LIVE')
and ts.date::date between current_date-1 and current_date+6
and ts.club_id=ts.home_team_id
order by ts.date::date asc,ts.club_name asc
;
