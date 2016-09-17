select team_name,count(*)
from (
select
g.team_name,
g.opponent_name,
(teo.exp_factor*tf.exp_factor*sft.offensive*opd.exp_factor) as etg,
(opo.exp_factor*of.exp_factor*sfo.offensive*ted.exp_factor) as eog
from club.results g
join club.teams t
  on (t.club_id,t.year)=(g.team_id,g.year)
join club._schedule_factors sft
  on (sft.team_id,sft.year)=(g.team_id,g.year)
join club.teams o
  on (o.club_id,o.year)=(g.opponent_id,g.year)
join club._schedule_factors sfo
  on (sfo.team_id,sfo.year)=(g.opponent_id,g.year)

join club._factors teo
  on (teo.parameter,teo.level)=('offense_league',t.league_key)
join club._factors ted
  on (ted.parameter,ted.level)=('defense_league',t.league_key)

join club._factors opo
  on (opo.parameter,opo.level)=('offense_league',o.league_key)
join club._factors opd
  on (opd.parameter,opd.level)=('defense_league',o.league_key)

join club._factors tf on
  tf.level='offense_home'
join club._factors of on
  of.level='defense_home'
where
    g.team_league_key = 'futebol+brasileiro'
and g.competition='Bras'
and ((g.game_date >= current_date) or (g.year=2016 and g.status='Postp'))
and ((g.team_score is null) or (g.opponent_score is null))

and g.field = 'offense_home'

order by team_name asc,game_date asc
) s
group by team_name;
