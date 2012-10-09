begin;

select
r.year,
t.div_id as div,
o.div_id as div,
sum(case when r.team_score>r.opponent_score then 1 else 0 end) as won,
sum(case when r.team_score<r.opponent_score then 1 else 0 end) as lost,
sum(case when r.team_score=r.opponent_score then 1 else 0 end) as tied,
count(*)
from ncaa.results r
left join ncaa.schools_divisions t
  on (t.school_id,t.year)=(r.school_id,r.year)
left join ncaa.schools_divisions o
  on (o.school_id,o.year)=(r.opponent_id,r.year)
where
    t.div_id<=o.div_id
and r.year between 2002 and 2013
group by r.year,t.div_id,o.div_id
order by r.year,t.div_id,o.div_id;

commit;
