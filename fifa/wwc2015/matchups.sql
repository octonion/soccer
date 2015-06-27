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

exp(bf.estimate)*h.offensive*v.defensive*o.exp_factor,
exp(bf.estimate)*v.offensive*h.defensive*d.exp_factor

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
join fifa.women_factors o
  on (o.parameter,o.level)=('field','offense_home')
join fifa.women_factors d
  on (d.parameter,d.level)=('field','defense_home')
join fifa.women_basic_factors bf
  on bf.factor='(Intercept)'

where

s1.team_id in
  ('can')
and s2.team_id in
  ('jpn', 'eng', 'ger',
   'usa', 'aus')
);

insert into m
(team_id,team_name,opponent_id,opponent_name,team_mu,opponent_mu)
(
select
s1.team_id,t1.team_name,s2.team_id,t2.team_name,

exp(bf.estimate)*h.offensive*v.defensive*d.exp_factor,
exp(bf.estimate)*v.offensive*h.defensive*o.exp_factor

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
join fifa.women_factors o
  on (o.parameter,o.level)=('field','offense_home')
join fifa.women_factors d
  on (d.parameter,d.level)=('field','defense_home')
join fifa.women_basic_factors bf
  on bf.factor='(Intercept)'

where

s1.team_id in
  ('jpn', 'eng', 'ger',
   'usa', 'aus')
and s2.team_id in
  ('can')
);

insert into m
(team_id,team_name,opponent_id,opponent_name,team_mu,opponent_mu)
(
select
s1.team_id,t1.team_name,s2.team_id,t2.team_name,

exp(bf.estimate)*h.offensive*v.defensive,
exp(bf.estimate)*v.offensive*h.defensive

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
  ('jpn', 'eng', 'ger',
   'usa', 'aus')
and s2.team_id in
  ('jpn', 'eng', 'ger',
   'usa', 'aus')
);

copy
(
select
team_name,
team_mu::numeric(4,1) as eg_reg,
--(f.exp_factor*team_mu)::numeric(4,1) as eg_ot,

opponent_name,
opponent_mu::numeric(4,1) as eg_reg,
--(f.exp_factor*opponent_mu)::numeric(4,1) as eg_ot,

(
skellam(team_mu,opponent_mu,'win')
+
skellam(team_mu,opponent_mu,'tie')*
skellam(team_mu*(f.exp_factor-1),opponent_mu*(f.exp_factor-1),'win')
+
skellam(team_mu,opponent_mu,'tie')*
skellam(team_mu*(f.exp_factor-1),opponent_mu*(f.exp_factor-1),'tie')*0.5
)::numeric(4,3) as win,

(
skellam(team_mu,opponent_mu,'lose')
+
skellam(team_mu,opponent_mu,'tie')*
skellam(team_mu*(f.exp_factor-1),opponent_mu*(f.exp_factor-1),'lose')
+
skellam(team_mu,opponent_mu,'tie')*
skellam(team_mu*(f.exp_factor-1),opponent_mu*(f.exp_factor-1),'tie')*0.5
)::numeric(4,3) as lose,

skellam(team_mu,opponent_mu,'win')::numeric(4,3) as win_reg,
skellam(team_mu,opponent_mu,'lose')::numeric(4,3) as lose_reg,
skellam(team_mu,opponent_mu,'tie')::numeric(4,3) as tie_reg,

(
skellam(team_mu,opponent_mu,'tie')*
skellam(team_mu*(f.exp_factor-1),opponent_mu*(f.exp_factor-1),'win')
)::numeric(4,3) as win_ot,

(
skellam(team_mu,opponent_mu,'tie')*
skellam(team_mu*(f.exp_factor-1),opponent_mu*(f.exp_factor-1),'lose')
)::numeric(4,3) as lose_ot,

(
skellam(team_mu,opponent_mu,'tie')*
skellam(team_mu*(f.exp_factor-1),opponent_mu*(f.exp_factor-1),'tie')*0.5
)::numeric(4,3) as win_pk,

(
skellam(team_mu,opponent_mu,'tie')*
skellam(team_mu*(f.exp_factor-1),opponent_mu*(f.exp_factor-1),'tie')*0.5
)::numeric(4,3) as lose_pk

from m
join fifa.women_factors f
  on (f.parameter,f.level) = ('game_length','1 OT')
order by team_name,opponent_name
) to '/tmp/matchups.csv' csv header;

commit;
