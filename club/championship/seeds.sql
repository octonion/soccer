begin;

drop table if exists club.seeds;

create table club.seeds (
       team_name	text,
       rank		integer,
       n		integer,
       primary key (team_name,rank)
);

insert into club.seeds
(team_name,rank,n)
(
select team,rank,count(*) as n
from club.sims
group by team,rank
order by rank asc, n desc
);

commit;

