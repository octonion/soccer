begin;

drop table if exists club.sims_premier;

create table club.sims_premier (
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

copy club.sims_premier from '/tmp/sims_premier.csv' csv header;

commit;
