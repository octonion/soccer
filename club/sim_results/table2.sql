select

g.team_name as team,
count(*) as p,

sum(
case when (team_score > opponent_score) then 1
else 0
end) as w,
sum(
case when (team_score=opponent_score) then 1
else 0
end) as d,
sum(
case when (team_score < opponent_score) then 1
else 0
end) as l,
sum(team_score) as gf,
sum(opponent_score) as ga,
sum(team_score-opponent_score) as gd,

sum(
case when (team_score > opponent_score) then 3
     when (team_score=opponent_score) then 1
else 0
end) as pts,

(coalesce(sc.n,0)::float/10000::float)::numeric(4,3) as champ,
((coalesce(sc.n,0)+coalesce(s2.n,0))::float/10000::float)::numeric(4,3) as top2,
((coalesce(sc.n,0)+coalesce(s2.n,0)+coalesce(s3.n,0))::float/10000::float)::numeric(4,3) as top3,
((coalesce(sc.n,0)+coalesce(s2.n,0)+coalesce(s3.n,0)+coalesce(s4.n,0))::float/10000::float)::numeric(4,3) as top4,
((coalesce(s5.n,0)+coalesce(s6.n,0)+coalesce(s7.n,0))::float/10000::float)::numeric(4,3) as "5-7",
((coalesce(l4.n,0)+coalesce(l3.n,0)+coalesce(l2.n,0)+coalesce(l1.n,0))::float/10000::float)::numeric(4,3) as bot4,
((coalesce(l3.n,0)+coalesce(l2.n,0)+coalesce(l1.n,0))::float/10000::float)::numeric(4,3) as bot3,
((coalesce(l2.n,0)+coalesce(l1.n,0))::float/10000::float)::numeric(4,3) as bot2

from club.results g
join club.intraleague_keys ik
  on (ik.league_key,ik.intraleague_key)=(g.team_league_key,g.competition)
join club.league_sizes ls
  on (ls.year,ls.league_key)=(g.year,g.team_league_key)
  
left join club.seeds sc
  on (g.team_name,1)=(sc.team_name,sc.rank)
left join club.seeds s2
  on (g.team_name,2)=(s2.team_name,s2.rank)
left join club.seeds s3
  on (g.team_name,3)=(s3.team_name,s3.rank)
left join club.seeds s4
  on (g.team_name,4)=(s4.team_name,s4.rank)
left join club.seeds s5
  on (g.team_name,5)=(s5.team_name,s5.rank)
left join club.seeds s6
  on (g.team_name,6)=(s6.team_name,s6.rank)
left join club.seeds s7
  on (g.team_name,7)=(s7.team_name,s7.rank)
left join club.seeds l4
  on (g.team_name,ls.n-3)=(l4.team_name,l4.rank)
left join club.seeds l3
  on (g.team_name,ls.n-2)=(l3.team_name,l3.rank)
left join club.seeds l2
  on (g.team_name,ls.n-1)=(l2.team_name,l2.rank)
left join club.seeds l1
  on (g.team_name,ls.n)=(l1.team_name,l1.rank)
where
--    not(g.date='LIVE')
    g.team_league_key = 'dummy_league_key'
--and g.competition='Bund'
and g.year=2017
and g.game_date <= current_date
and g.team_score is not null
and g.opponent_score is not null
and not(g.status like '%''')

group by g.team_name,champ,top2,top3,top4,"5-7",bot4,bot3,bot2
order by pts desc,gd desc,gf desc;
