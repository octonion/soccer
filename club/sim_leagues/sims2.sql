begin;

drop table if exists club.sims;

create table club.sims (
	team		      text,
	n		      integer,
	rank		      integer,
	w		      integer,
	d		      integer,
	l		      integer,
	gf		      integer,
	ga		      integer,
	gd		      integer,
	pts		      integer,
	primary key (team,n)
);

copy club.sims from '/tmp/sims.csv' csv header;

commit;
