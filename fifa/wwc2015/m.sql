begin;

create temporary table m (
       team_id	       text,
       team_name       text,
       opponent_id     text,
       opponent_name   text,
       team_mu	       float,
       opponent_mu     float
);

insert into m
(team_id,team_name,opponent_id,opponent_name,team_mu,opponent_mu)
(
select
s1.team_id,t1.team_name,s2.team_id,t2.team_name,

exp(bf.estimate)*h.offensive*v.defensive*((94.0-90.0)/94.0),
exp(bf.estimate)*v.offensive*h.defensive*((94.0-90.0)/94.0)

from fifa.women_schedule_factors s1
join fifa.women_schedule_factors s2
  on (s1.team_id<>s2.team_id)
join fifa.teams t1
  on (t1.team_id,t1.gender_id)=(s1.team_id,'women')
join fifa.teams t2
  on (t2.team_id,t2.gender_id)=(s2.team_id,'women')
join fifa.women_schedule_factors h
  on (h.team_id)=(t1.team_id)
join fifa.women_schedule_factors v
  on (v.team_id)=(t2.team_id)
join fifa.women_basic_factors bf
  on bf.factor='(Intercept)'

where

s1.team_id in
  ('jpn', 'ned')
and s2.team_id in
  ('jpn', 'ned')
);

select
team_name,
team_mu::numeric(4,1) as eg_reg,
--(f.exp_factor*team_mu)::numeric(4,1) as eg_ot,

opponent_name,
opponent_mu::numeric(4,1) as eg_reg,
--(f.exp_factor*opponent_mu)::numeric(4,1) as eg_ot,

(
skellam2(team_mu,opponent_mu,((94.0-90.0)/94.0),1,'win')
+
skellam2(team_mu,opponent_mu,((94.0-90.0)/94.0),1,'tie')*
skellam(team_mu*(f.exp_factor-1),opponent_mu*(f.exp_factor-1),'win')
+
skellam2(team_mu,opponent_mu,((94.0-90.0)/94.0),1,'tie')*
skellam(team_mu*(f.exp_factor-1),opponent_mu*(f.exp_factor-1),'tie')*((94.0-90.0)/94.0)
)::numeric(7,6) as win,

(
skellam2(team_mu,opponent_mu,((94.0-90.0)/94.0),1,'lose')
+
skellam2(team_mu,opponent_mu,((94.0-90.0)/94.0),1,'tie')*
skellam(team_mu*(f.exp_factor-1),opponent_mu*(f.exp_factor-1),'lose')
+
skellam2(team_mu,opponent_mu,((94.0-90.0)/94.0),1,'tie')*
skellam(team_mu*(f.exp_factor-1),opponent_mu*(f.exp_factor-1),'tie')*((94.0-90.0)/94.0)
)::numeric(7,6) as lose,

skellam2(team_mu,opponent_mu,((94.0-90.0)/94.0),1,'win')::numeric(7,6) as win_reg,
skellam2(team_mu,opponent_mu,((94.0-90.0)/94.0),1,'lose')::numeric(7,6) as lose_reg,
skellam2(team_mu,opponent_mu,((94.0-90.0)/94.0),1,'tie')::numeric(7,6) as tie_reg,

(
skellam2(team_mu,opponent_mu,((94.0-90.0)/94.0),1,'tie')*
skellam(team_mu*(f.exp_factor-1),opponent_mu*(f.exp_factor-1),'win')
)::numeric(7,6) as win_ot,

(
skellam2(team_mu,opponent_mu,((94.0-90.0)/94.0),1,'tie')*
skellam(team_mu*(f.exp_factor-1),opponent_mu*(f.exp_factor-1),'lose')
)::numeric(7,6) as lose_ot,

(
skellam2(team_mu,opponent_mu,((94.0-90.0)/94.0),1,'tie')*
skellam(team_mu*(f.exp_factor-1),opponent_mu*(f.exp_factor-1),'tie')*((94.0-90.0)/94.0)
)::numeric(7,6) as win_pk,

(
skellam2(team_mu,opponent_mu,((94.0-90.0)/94.0),1,'tie')*
skellam(team_mu*(f.exp_factor-1),opponent_mu*(f.exp_factor-1),'tie')*((94.0-90.0)/94.0)
)::numeric(7,6) as lose_pk

from m
join fifa.women_factors f
  on (f.parameter,f.level) = ('game_length','1 OT')
order by team_name,opponent_name;

commit;
