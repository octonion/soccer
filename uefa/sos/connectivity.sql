begin;

select
r.year,
t.div_id as div,
o.div_id as div,
sum(case when r.team_score>r.opponent_score then 1 else 0 end) as won,
sum(case when r.team_score<r.opponent_score then 1 else 0 end) as lost,
sum(case when r.team_score=r.opponent_score then 1 else 0 end) as tied,
count(*)
from uefa.results r
left join uefa.teams_divisions t
  on (t.team_id,t.year)=(r.team_id,r.year)
left join uefa.teams_divisions o
  on (o.team_id,o.year)=(r.opponent_id,r.year)
where
    t.div_id<=o.div_id
and r.year between 2012 and 2008
group by r.year,t.div_id,o.div_id
order by r.year,t.div_id,o.div_id;

commit;
