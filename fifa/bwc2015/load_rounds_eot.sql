begin;

-- rounds

drop table if exists fifa.rounds;

create table fifa.rounds (
	year				integer,
	round_id			integer,
	team_id				text,
	team_name			text,
	bracket				int[],
	p				float,
	primary key (year,round_id,team_id)
);

copy fifa.rounds from '/tmp/rounds.csv' with delimiter as ',' csv header quote as '"';

-- matchup probabilities

drop table if exists fifa.matrix_p;

create table fifa.matrix_p (
	year				integer,
	field				text,
	team_id				text,
	opponent_id			text,
	team_p				float,
	opponent_p			float,
	primary key (year,field,team_id,opponent_id)
);

insert into fifa.matrix_p
(year,field,team_id,opponent_id,team_p,opponent_p)
(select
r1.year,
'home',
r1.team_id,
r2.team_id,

skellam(exp(bf.estimate)*h.offensive*v.defensive*o.exp_factor,
	exp(bf.estimate)*v.offensive*h.defensive*d.exp_factor,'win')
+
skellam(exp(bf.estimate)*h.offensive*v.defensive*o.exp_factor,
	exp(bf.estimate)*v.offensive*h.defensive*d.exp_factor,'tie')
*
skellam(exp(bf.estimate)*h.offensive*v.defensive*o.exp_factor*(f.exp_factor-1),
	exp(bf.estimate)*v.offensive*h.defensive*d.exp_factor*(f.exp_factor-1),'win')
+
0.5*
skellam(exp(bf.estimate)*h.offensive*v.defensive*o.exp_factor,
	exp(bf.estimate)*v.offensive*h.defensive*d.exp_factor,'tie')
*
skellam(exp(bf.estimate)*h.offensive*v.defensive*o.exp_factor*(f.exp_factor-1),
	exp(bf.estimate)*v.offensive*h.defensive*d.exp_factor*(f.exp_factor-1),'tie')
as home_p,

1.0-
(
skellam(exp(bf.estimate)*h.offensive*v.defensive*o.exp_factor,
	exp(bf.estimate)*v.offensive*h.defensive*d.exp_factor,'win')
+
skellam(exp(bf.estimate)*h.offensive*v.defensive*o.exp_factor,
	exp(bf.estimate)*v.offensive*h.defensive*d.exp_factor,'tie')
*
skellam(exp(bf.estimate)*h.offensive*v.defensive*o.exp_factor*(f.exp_factor-1),
	exp(bf.estimate)*v.offensive*h.defensive*d.exp_factor*(f.exp_factor-1),'win')
+
0.5*
skellam(exp(bf.estimate)*h.offensive*v.defensive*o.exp_factor,
	exp(bf.estimate)*v.offensive*h.defensive*d.exp_factor,'tie')
*
skellam(exp(bf.estimate)*h.offensive*v.defensive*o.exp_factor*(f.exp_factor-1),
	exp(bf.estimate)*v.offensive*h.defensive*d.exp_factor*(f.exp_factor-1),'tie')
)
as visitor_p

from fifa.rounds r1
join fifa.rounds r2
  on ((r2.year)=(r1.year) and not((r2.team_id)=(r1.team_id)))
join fifa._schedule_factors v
  on (v.team_id)=(r2.team_id)
join fifa._schedule_factors h
  on (h.team_id)=(r1.team_id)
join fifa._factors o
  on (o.parameter,o.level)=('field','offense_home')
join fifa._factors d
  on (d.parameter,d.level)=('field','defense_home')
join fifa._basic_factors bf
  on bf.factor='(Intercept)'
join fifa._factors f
  on (f.parameter,f.level) = ('game_length','1 OT')
where
  r1.year=2015
);

insert into fifa.matrix_p
(year,field,team_id,opponent_id,team_p,opponent_p)
(select
r1.year,
'away',
r1.team_id,
r2.team_id,

skellam(exp(bf.estimate)*h.offensive*v.defensive*d.exp_factor,
	exp(bf.estimate)*v.offensive*h.defensive*o.exp_factor,'win')
+
skellam(exp(bf.estimate)*h.offensive*v.defensive*d.exp_factor,
	exp(bf.estimate)*v.offensive*h.defensive*o.exp_factor,'tie')
*
skellam(exp(bf.estimate)*h.offensive*v.defensive*d.exp_factor*(f.exp_factor-1),
	exp(bf.estimate)*v.offensive*h.defensive*o.exp_factor*(f.exp_factor-1),'win')
+
0.5*
skellam(exp(bf.estimate)*h.offensive*v.defensive*d.exp_factor,
	exp(bf.estimate)*v.offensive*h.defensive*o.exp_factor,'tie')
*
skellam(exp(bf.estimate)*h.offensive*v.defensive*d.exp_factor*(f.exp_factor-1),
	exp(bf.estimate)*v.offensive*h.defensive*o.exp_factor*(f.exp_factor-1),'tie')
as home_p,

1.0-
(
skellam(exp(bf.estimate)*h.offensive*v.defensive*d.exp_factor,
	exp(bf.estimate)*v.offensive*h.defensive*o.exp_factor,'win')
+
skellam(exp(bf.estimate)*h.offensive*v.defensive*d.exp_factor,
	exp(bf.estimate)*v.offensive*h.defensive*o.exp_factor,'tie')
*
skellam(exp(bf.estimate)*h.offensive*v.defensive*d.exp_factor*(f.exp_factor-1),
	exp(bf.estimate)*v.offensive*h.defensive*o.exp_factor*(f.exp_factor-1),'win')
+
0.5*
skellam(exp(bf.estimate)*h.offensive*v.defensive*d.exp_factor,
	exp(bf.estimate)*v.offensive*h.defensive*o.exp_factor,'tie')
*
skellam(exp(bf.estimate)*h.offensive*v.defensive*d.exp_factor*(f.exp_factor-1),
	exp(bf.estimate)*v.offensive*h.defensive*o.exp_factor*(f.exp_factor-1),'tie')
)
as visitor_p

from fifa.rounds r1
join fifa.rounds r2
  on ((r2.year)=(r1.year) and not((r2.team_id)=(r1.team_id)))
join fifa._schedule_factors v
  on (v.team_id)=(r2.team_id)
join fifa._schedule_factors h
  on (h.team_id)=(r1.team_id)
join fifa._factors o
  on (o.parameter,o.level)=('field','offense_home')
join fifa._factors d
  on (d.parameter,d.level)=('field','defense_home')
join fifa._basic_factors bf
  on bf.factor='(Intercept)'
join fifa._factors f
  on (f.parameter,f.level) = ('game_length','1 OT')
where
  r1.year=2015
);

insert into fifa.matrix_p
(year,field,team_id,opponent_id,team_p,opponent_p)
(select
r1.year,
'neutral',
r1.team_id,
r2.team_id,

skellam(exp(bf.estimate)*h.offensive*v.defensive,
	exp(bf.estimate)*v.offensive*h.defensive,'win')
+
skellam(exp(bf.estimate)*h.offensive*v.defensive,
	exp(bf.estimate)*v.offensive*h.defensive,'tie')
*
skellam(exp(bf.estimate)*h.offensive*v.defensive*(f.exp_factor-1),
	exp(bf.estimate)*v.offensive*h.defensive*(f.exp_factor-1),'win')
+
0.5*
skellam(exp(bf.estimate)*h.offensive*v.defensive,
	exp(bf.estimate)*v.offensive*h.defensive,'tie')
*
skellam(exp(bf.estimate)*h.offensive*v.defensive*(f.exp_factor-1),
	exp(bf.estimate)*v.offensive*h.defensive*(f.exp_factor-1),'tie')
as home_p,

1.0-
(
skellam(exp(bf.estimate)*h.offensive*v.defensive,
	exp(bf.estimate)*v.offensive*h.defensive,'win')
+
skellam(exp(bf.estimate)*h.offensive*v.defensive,
	exp(bf.estimate)*v.offensive*h.defensive,'tie')
*
skellam(exp(bf.estimate)*h.offensive*v.defensive*(f.exp_factor-1),
	exp(bf.estimate)*v.offensive*h.defensive*(f.exp_factor-1),'win')
+
0.5*
skellam(exp(bf.estimate)*h.offensive*v.defensive,
	exp(bf.estimate)*v.offensive*h.defensive,'tie')
*
skellam(exp(bf.estimate)*h.offensive*v.defensive*(f.exp_factor-1),
	exp(bf.estimate)*v.offensive*h.defensive*(f.exp_factor-1),'tie')
)
as visitor_p

from fifa.rounds r1
join fifa.rounds r2
  on ((r2.year)=(r1.year) and not((r2.team_id)=(r1.team_id)))
join fifa._schedule_factors v
  on (v.team_id)=(r2.team_id)
join fifa._schedule_factors h
  on (h.team_id)=(r1.team_id)
join fifa._basic_factors bf
  on bf.factor='(Intercept)'
join fifa._factors f
  on (f.parameter,f.level) = ('game_length','1 OT')
where
  r1.year=2015
);

-- home advantage

drop table if exists fifa.matrix_field;

create table fifa.matrix_field (
	year				integer,
	round_id			integer,
	team_id				text,
	opponent_id			text,
	field				text,
	primary key (year,round_id,team_id,opponent_id)
);

insert into fifa.matrix_field
(year,round_id,team_id,opponent_id,field)
(select
r1.year,
gs.round_id,
r1.team_id,
r2.team_id,
'neutral'
from fifa.rounds r1
join fifa.rounds r2
  on (r2.year=r1.year and not(r2.team_id=r1.team_id))
join (select generate_series(1, 5) round_id) gs
  on TRUE
where
  r1.year=2015
);

-- Canada

update fifa.matrix_field
set field='home'
where (year,team_id)=(2015,'can');

update fifa.matrix_field
set field='away'
where (year,opponent_id)=(2015,'can');

commit;
