begin;

-- rounds

drop table if exists fifa.men_rounds;

create table fifa.men_rounds (
	year				integer,
	round_id			integer,
	team_id				text,
	team_name			text,
	bracket				int[],
	p				float,
	primary key (year,round_id,team_id)
);

copy fifa.men_rounds from '/tmp/rounds.csv' with delimiter as ',' csv header quote as '"';

-- matchup probabilities

drop table if exists fifa.men_matrix_p;

create table fifa.men_matrix_p (
	year				integer,
	field				text,
	rules				text,
	team_id				text,
	opponent_id			text,
	team_p				float,
	opponent_p			float,
	primary key (year,field,rules,team_id,opponent_id)
);

-- 30 minutes extra time

insert into fifa.men_matrix_p
(year,
field,
rules,
team_id,opponent_id,
team_p,opponent_p)
(select
r1.year,
'home',
'extra time',
r1.team_id,
r2.team_id,

skellam(exp(bf.estimate)*h.offensive*v.defensive*(o.exp_factor*o.exp_factor),
	exp(bf.estimate)*v.offensive*h.defensive*(d.exp_factor*d.exp_factor),'win')
+
skellam(exp(bf.estimate)*h.offensive*v.defensive*(o.exp_factor*o.exp_factor),
	exp(bf.estimate)*v.offensive*h.defensive*(d.exp_factor*d.exp_factor),'draw')
*
skellam(exp(bf.estimate)*h.offensive*v.defensive*(o.exp_factor*o.exp_factor)*(f.exp_factor-1),
	exp(bf.estimate)*v.offensive*h.defensive*(d.exp_factor*d.exp_factor)*(f.exp_factor-1),'win')
+
0.5*
skellam(exp(bf.estimate)*h.offensive*v.defensive*(o.exp_factor*o.exp_factor),
	exp(bf.estimate)*v.offensive*h.defensive*(d.exp_factor*d.exp_factor),'draw')
*
skellam(exp(bf.estimate)*h.offensive*v.defensive*(o.exp_factor*o.exp_factor)*(f.exp_factor-1),
	exp(bf.estimate)*v.offensive*h.defensive*(d.exp_factor*d.exp_factor)*(f.exp_factor-1),'draw')
as home_p,

1.0-
(
skellam(exp(bf.estimate)*h.offensive*v.defensive*(o.exp_factor*o.exp_factor),
	exp(bf.estimate)*v.offensive*h.defensive*(d.exp_factor*d.exp_factor),'win')
+
skellam(exp(bf.estimate)*h.offensive*v.defensive*(o.exp_factor*o.exp_factor),
	exp(bf.estimate)*v.offensive*h.defensive*(d.exp_factor*d.exp_factor),'draw')
*
skellam(exp(bf.estimate)*h.offensive*v.defensive*(o.exp_factor*o.exp_factor)*(f.exp_factor-1),
	exp(bf.estimate)*v.offensive*h.defensive*(d.exp_factor*d.exp_factor)*(f.exp_factor-1),'win')
+
0.5*
skellam(exp(bf.estimate)*h.offensive*v.defensive*(o.exp_factor*o.exp_factor),
	exp(bf.estimate)*v.offensive*h.defensive*(d.exp_factor*d.exp_factor),'draw')
*
skellam(exp(bf.estimate)*h.offensive*v.defensive*(o.exp_factor*o.exp_factor)*(f.exp_factor-1),
	exp(bf.estimate)*v.offensive*h.defensive*(d.exp_factor*d.exp_factor)*(f.exp_factor-1),'draw')
)
as visitor_p

from fifa.men_rounds r1
join fifa.men_rounds r2
  on ((r2.year)=(r1.year) and not((r2.team_id)=(r1.team_id)))
join fifa.men_schedule_factors v
  on (v.team_id)=(r2.team_id)
join fifa.men_schedule_factors h
  on (h.team_id)=(r1.team_id)
join fifa.men_factors o
  on (o.parameter,o.level)=('field','offense_home')
join fifa.men_factors d
  on (d.parameter,d.level)=('field','defense_home')
join fifa.men_basic_factors bf
  on bf.factor='(Intercept)'
join fifa.men_factors f
  on (f.parameter,f.level) = ('game_length','1 OT')
where
  r1.year=2016
);

insert into fifa.men_matrix_p
(year,
field,
rules,
team_id,opponent_id,
team_p,opponent_p)
(select
r1.year,
'away',
'extra time',
r1.team_id,
r2.team_id,

skellam(exp(bf.estimate)*h.offensive*v.defensive*(d.exp_factor*d.exp_factor),
	exp(bf.estimate)*v.offensive*h.defensive*(o.exp_factor*o.exp_factor),'win')
+
skellam(exp(bf.estimate)*h.offensive*v.defensive*(d.exp_factor*d.exp_factor),
	exp(bf.estimate)*v.offensive*h.defensive*(o.exp_factor*o.exp_factor),'draw')
*
skellam(exp(bf.estimate)*h.offensive*v.defensive*(d.exp_factor*d.exp_factor)*(f.exp_factor-1),
	exp(bf.estimate)*v.offensive*h.defensive*(o.exp_factor*o.exp_factor)*(f.exp_factor-1),'win')
+
0.5*
skellam(exp(bf.estimate)*h.offensive*v.defensive*(d.exp_factor*d.exp_factor),
	exp(bf.estimate)*v.offensive*h.defensive*(o.exp_factor*o.exp_factor),'draw')
*
skellam(exp(bf.estimate)*h.offensive*v.defensive*(d.exp_factor*d.exp_factor)*(f.exp_factor-1),
	exp(bf.estimate)*v.offensive*h.defensive*(o.exp_factor*o.exp_factor)*(f.exp_factor-1),'draw')
as home_p,

1.0-
(
skellam(exp(bf.estimate)*h.offensive*v.defensive*(d.exp_factor*d.exp_factor),
	exp(bf.estimate)*v.offensive*h.defensive*(o.exp_factor*o.exp_factor),'win')
+
skellam(exp(bf.estimate)*h.offensive*v.defensive*(d.exp_factor*d.exp_factor),
	exp(bf.estimate)*v.offensive*h.defensive*(o.exp_factor*o.exp_factor),'draw')
*
skellam(exp(bf.estimate)*h.offensive*v.defensive*(d.exp_factor*d.exp_factor)*(f.exp_factor-1),
	exp(bf.estimate)*v.offensive*h.defensive*(o.exp_factor*o.exp_factor)*(f.exp_factor-1),'win')
+
0.5*
skellam(exp(bf.estimate)*h.offensive*v.defensive*(d.exp_factor*d.exp_factor),
	exp(bf.estimate)*v.offensive*h.defensive*(o.exp_factor*o.exp_factor),'draw')
*
skellam(exp(bf.estimate)*h.offensive*v.defensive*(d.exp_factor*d.exp_factor)*(f.exp_factor-1),
	exp(bf.estimate)*v.offensive*h.defensive*(o.exp_factor*o.exp_factor)*(f.exp_factor-1),'draw')
)
as visitor_p

from fifa.men_rounds r1
join fifa.men_rounds r2
  on ((r2.year)=(r1.year) and not((r2.team_id)=(r1.team_id)))
join fifa.men_schedule_factors v
  on (v.team_id)=(r2.team_id)
join fifa.men_schedule_factors h
  on (h.team_id)=(r1.team_id)
join fifa.men_factors o
  on (o.parameter,o.level)=('field','offense_home')
join fifa.men_factors d
  on (d.parameter,d.level)=('field','defense_home')
join fifa.men_basic_factors bf
  on bf.factor='(Intercept)'
join fifa.men_factors f
  on (f.parameter,f.level) = ('game_length','1 OT')
where
  r1.year=2016
);

insert into fifa.men_matrix_p
(year,
field,
rules,
team_id,opponent_id,
team_p,opponent_p)
(select
r1.year,
'neutral',
'extra time',
r1.team_id,
r2.team_id,

skellam(exp(bf.estimate)*h.offensive*v.defensive,
	exp(bf.estimate)*v.offensive*h.defensive,'win')
+
skellam(exp(bf.estimate)*h.offensive*v.defensive,
	exp(bf.estimate)*v.offensive*h.defensive,'draw')
*
skellam(exp(bf.estimate)*h.offensive*v.defensive*(f.exp_factor-1),
	exp(bf.estimate)*v.offensive*h.defensive*(f.exp_factor-1),'win')
+
0.5*
skellam(exp(bf.estimate)*h.offensive*v.defensive,
	exp(bf.estimate)*v.offensive*h.defensive,'draw')
*
skellam(exp(bf.estimate)*h.offensive*v.defensive*(f.exp_factor-1),
	exp(bf.estimate)*v.offensive*h.defensive*(f.exp_factor-1),'draw')
as home_p,

1.0-
(
skellam(exp(bf.estimate)*h.offensive*v.defensive,
	exp(bf.estimate)*v.offensive*h.defensive,'win')
+
skellam(exp(bf.estimate)*h.offensive*v.defensive,
	exp(bf.estimate)*v.offensive*h.defensive,'draw')
*
skellam(exp(bf.estimate)*h.offensive*v.defensive*(f.exp_factor-1),
	exp(bf.estimate)*v.offensive*h.defensive*(f.exp_factor-1),'win')
+
0.5*
skellam(exp(bf.estimate)*h.offensive*v.defensive,
	exp(bf.estimate)*v.offensive*h.defensive,'draw')
*
skellam(exp(bf.estimate)*h.offensive*v.defensive*(f.exp_factor-1),
	exp(bf.estimate)*v.offensive*h.defensive*(f.exp_factor-1),'draw')
)
as visitor_p

from fifa.men_rounds r1
join fifa.men_rounds r2
  on ((r2.year)=(r1.year) and not((r2.team_id)=(r1.team_id)))
join fifa.men_schedule_factors v
  on (v.team_id)=(r2.team_id)
join fifa.men_schedule_factors h
  on (h.team_id)=(r1.team_id)
join fifa.men_basic_factors bf
  on bf.factor='(Intercept)'
join fifa.men_factors f
  on (f.parameter,f.level) = ('game_length','1 OT')
where
  r1.year=2016
);

-- No extra time

insert into fifa.men_matrix_p
(year,
field,
rules,
team_id,opponent_id,
team_p,opponent_p)
(select
r1.year,
'home',
'no extra time',
r1.team_id,
r2.team_id,

skellam(exp(bf.estimate)*h.offensive*v.defensive*(o.exp_factor*o.exp_factor),
	exp(bf.estimate)*v.offensive*h.defensive*(d.exp_factor*d.exp_factor),'win')
+
0.5*
skellam(exp(bf.estimate)*h.offensive*v.defensive*(o.exp_factor*o.exp_factor),
	exp(bf.estimate)*v.offensive*h.defensive*(d.exp_factor*d.exp_factor),'draw')
as home_p,

1.0-
(
skellam(exp(bf.estimate)*h.offensive*v.defensive*(o.exp_factor*o.exp_factor),
	exp(bf.estimate)*v.offensive*h.defensive*(d.exp_factor*d.exp_factor),'win')
+
0.5*
skellam(exp(bf.estimate)*h.offensive*v.defensive*(o.exp_factor*o.exp_factor),
	exp(bf.estimate)*v.offensive*h.defensive*(d.exp_factor*d.exp_factor),'draw')
)
as visitor_p

from fifa.men_rounds r1
join fifa.men_rounds r2
  on ((r2.year)=(r1.year) and not((r2.team_id)=(r1.team_id)))
join fifa.men_schedule_factors v
  on (v.team_id)=(r2.team_id)
join fifa.men_schedule_factors h
  on (h.team_id)=(r1.team_id)
join fifa.men_factors o
  on (o.parameter,o.level)=('field','offense_home')
join fifa.men_factors d
  on (d.parameter,d.level)=('field','defense_home')
join fifa.men_basic_factors bf
  on bf.factor='(Intercept)'
join fifa.men_factors f
  on (f.parameter,f.level) = ('game_length','1 OT')
where
  r1.year=2016
);

insert into fifa.men_matrix_p
(year,
field,
rules,
team_id,opponent_id,
team_p,opponent_p)
(select
r1.year,
'away',
'no extra time',
r1.team_id,
r2.team_id,

skellam(exp(bf.estimate)*h.offensive*v.defensive*(d.exp_factor*d.exp_factor),
	exp(bf.estimate)*v.offensive*h.defensive*(o.exp_factor*o.exp_factor),'win')
+
0.5*
skellam(exp(bf.estimate)*h.offensive*v.defensive*(d.exp_factor*d.exp_factor),
	exp(bf.estimate)*v.offensive*h.defensive*(o.exp_factor*o.exp_factor),'draw')
as home_p,

1.0-
(
skellam(exp(bf.estimate)*h.offensive*v.defensive*(d.exp_factor*d.exp_factor),
	exp(bf.estimate)*v.offensive*h.defensive*(o.exp_factor*o.exp_factor),'win')
+
0.5*
skellam(exp(bf.estimate)*h.offensive*v.defensive*(d.exp_factor*d.exp_factor),
	exp(bf.estimate)*v.offensive*h.defensive*(o.exp_factor*o.exp_factor),'draw')
)
as visitor_p

from fifa.men_rounds r1
join fifa.men_rounds r2
  on ((r2.year)=(r1.year) and not((r2.team_id)=(r1.team_id)))
join fifa.men_schedule_factors v
  on (v.team_id)=(r2.team_id)
join fifa.men_schedule_factors h
  on (h.team_id)=(r1.team_id)
join fifa.men_factors o
  on (o.parameter,o.level)=('field','offense_home')
join fifa.men_factors d
  on (d.parameter,d.level)=('field','defense_home')
join fifa.men_basic_factors bf
  on bf.factor='(Intercept)'
join fifa.men_factors f
  on (f.parameter,f.level) = ('game_length','1 OT')
where
  r1.year=2016
);

insert into fifa.men_matrix_p
(year,
field,
rules,
team_id,opponent_id,
team_p,opponent_p)
(select
r1.year,
'neutral',
'no extra time',
r1.team_id,
r2.team_id,

skellam(exp(bf.estimate)*h.offensive*v.defensive,
	exp(bf.estimate)*v.offensive*h.defensive,'win')
+
0.5*
skellam(exp(bf.estimate)*h.offensive*v.defensive,
	exp(bf.estimate)*v.offensive*h.defensive,'draw')
as home_p,

1.0-
(
skellam(exp(bf.estimate)*h.offensive*v.defensive,
	exp(bf.estimate)*v.offensive*h.defensive,'win')
+
0.5*
skellam(exp(bf.estimate)*h.offensive*v.defensive,
	exp(bf.estimate)*v.offensive*h.defensive,'draw')
)
as visitor_p

from fifa.men_rounds r1
join fifa.men_rounds r2
  on ((r2.year)=(r1.year) and not((r2.team_id)=(r1.team_id)))
join fifa.men_schedule_factors v
  on (v.team_id)=(r2.team_id)
join fifa.men_schedule_factors h
  on (h.team_id)=(r1.team_id)
join fifa.men_basic_factors bf
  on bf.factor='(Intercept)'
join fifa.men_factors f
  on (f.parameter,f.level) = ('game_length','1 OT')
where
  r1.year=2016
);

-- home advantage

drop table if exists fifa.men_matrix_field;

create table fifa.men_matrix_field (
	year				integer,
	round_id			integer,
	team_id				text,
	opponent_id			text,
	field				text,
	primary key (year,round_id,team_id,opponent_id)
);

insert into fifa.men_matrix_field
(year,round_id,team_id,opponent_id,field)
(select
r1.year,
gs.round_id,
r1.team_id,
r2.team_id,
'neutral'
from fifa.men_rounds r1
join fifa.men_rounds r2
  on (r2.year=r1.year and not(r2.team_id=r1.team_id))
join (select generate_series(1, 5) round_id) gs
  on TRUE
where
  r1.year=2016
);

-- France

update fifa.men_matrix_field
set field='home'
where (year,team_id)=(2016,'fra');

update fifa.men_matrix_field
set field='away'
where (year,opponent_id)=(2016,'fra');

commit;
