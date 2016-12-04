begin;

create temporary table c (
       league_key      text,
       competition     text,
       n	       integer
);

insert into c
(league_key,competition,n)
(
select
team_league_key,
competition,
count(*)
from club.results
where not(competition='')
group by team_league_key,competition
);

drop table if exists club.intraleague_keys;

create table club.intraleague_keys (
       league_key		   text,
       intraleague_key		   text,
       primary key (league_key)
);

insert into club.intraleague_keys
(league_key,intraleague_key)
(
select league_key,competition
from c c1
where n=(
select max(n)
from c c2
where (c2.league_key)=(c1.league_key)
and not(c1.league_key='north+american+soccer+league')
)
);

commit;
