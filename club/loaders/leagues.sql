begin;

drop table if exists club.leagues;

create table club.leagues (
	league_id	      integer,
	league_key	      text,
	league_name	      text,
	league_url	      text,
	primary key (league_id)
);

copy club.leagues from '/tmp/leagues.tsv' with delimiter as E'\t' csv header;

commit;
