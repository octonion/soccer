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
((coalesce(sc.n,0)+coalesce(s2.n,0)+coalesce(s3.n,0)+coalesce(s4.n,0))::float/10000::float)::numeric(4,3) as "1-4",
((coalesce(s5.n,0)+coalesce(s6.n,0)+coalesce(s7.n,0))::float/10000::float)::numeric(4,3) as "5-7",
((coalesce(s18.n,0)+coalesce(s19.n,0)+coalesce(s20.n,0))::float/10000::float)::numeric(4,3) as rlg

from club.results g
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
left join club.seeds s18
  on (g.team_name,18)=(s18.team_name,s18.rank)
left join club.seeds s19
  on (g.team_name,19)=(s19.team_name,s19.rank)
left join club.seeds s20
  on (g.team_name,20)=(s20.team_name,s20.rank)
where
--    not(g.date='LIVE')
    g.team_league_key = 'english+league+championship'
and g.competition='LC'
and g.year=2016
and g.game_date <= current_date
and g.team_score is not null
and g.opponent_score is not null
group by g.team_name,champ,"1-4","5-7",rlg
order by pts desc,gd desc,gf desc;
