begin;

drop table if exists club.sims_bundesliga;

create table club.sims_bundesliga (
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

copy club.sims_bundesliga from '/tmp/sims_bundesliga.csv' csv header;

commit;
