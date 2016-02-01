begin;

drop table if exists club.sims;

create table club.sims (
	team		      text,
	rank		      integer
);

copy club.sims from '/tmp/sims.csv' csv header;

commit;
