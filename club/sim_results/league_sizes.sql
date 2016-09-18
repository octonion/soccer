begin;

drop table if exists club.league_sizes;

create table club.league_sizes (
     year      		       integer,
     league_key		       text,
     n			       integer,
     primary key (year,league_key)
);

insert into club.league_sizes
(year,league_key,n)
(
select
year,
league_key,
count(*) as n
from club.teams
group by year,league_key
);

commit;

