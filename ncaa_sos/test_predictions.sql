select

r.year,

(sum(
case when ((t.strength*f.exp_factor)>(o.strength/f.exp_factor)
            and r.team_score>r.opponent_score) then 1
     when ((t.strength*f.exp_factor)<(o.strength/f.exp_factor)
            and r.team_score<r.opponent_score) then 1
else 0 end)::float/
count(*))::numeric(4,3) as model,

(
sum(
case when r.team_score>r.opponent_score and r.field='offense_home' then 1
     when r.team_score<r.opponent_score and r.field='defense_home' then 1
     when r.field='none' then 0.5
     else 0 end)::float/
--sum(
count(*)
--case when r.field in ('offense_home','defense_home') then 1
--     else 0.5
--end)
)::numeric(4,3) as naive,

(
sum(
case when ((t.strength*f.exp_factor)>(o.strength/f.exp_factor)
            and r.team_score>r.opponent_score) then 1
     when ((t.strength*f.exp_factor)<(o.strength/f.exp_factor)
            and r.team_score<r.opponent_score) then 1
else 0
end)::float/
count(*)

-

sum(
case when r.team_score>r.opponent_score and r.field='offense_home' then 1
     when r.team_score<r.opponent_score and r.field='defense_home' then 1
     when r.field='none' then 0.5
     else 0 end)::float/
--sum(
--case when r.field in ('offense_home','defense_home') then 1
--     else 0
--end)
count(*)
)::numeric(4,3) as diff,
count(*)
from ncaa.results r
join ncaa._schedule_factors t
  on (t.year,t.school_id)=(r.year,r.school_id)
join ncaa._schedule_factors o
  on (o.year,o.school_id)=(r.year,r.opponent_id)
join ncaa._factors f
  on (f.parameter,f.level)=('field',r.field)
where

TRUE

-- each game once

and r.school_id > r.opponent_id

-- test November and December

and extract(month from r.game_date) in (11,12)

-- D1

--and r.team_div_id=1
--and r.opponent_div_id=1

group by r.year
order by r.year;

select

(sum(
case when ((t.strength*f.exp_factor)>(o.strength/f.exp_factor)
            and r.team_score>r.opponent_score) then 1
     when ((t.strength*f.exp_factor)<(o.strength/f.exp_factor)
            and r.team_score<r.opponent_score) then 1
else 0 end)::float/
count(*))::numeric(4,3) as model,

(
sum(
case when r.team_score>r.opponent_score and r.field='offense_home' then 1
     when r.team_score<r.opponent_score and r.field='defense_home' then 1
     when r.field='none' then 0.5
     else 0 end)::float/
--sum(
count(*)
--case when r.field in ('offense_home','defense_home') then 1
--     else 0.5
--end)
)::numeric(4,3) as naive,

(
sum(
case when ((t.strength*f.exp_factor)>(o.strength/f.exp_factor)
            and r.team_score>r.opponent_score) then 1
     when ((t.strength*f.exp_factor)<(o.strength/f.exp_factor)
            and r.team_score<r.opponent_score) then 1
else 0
end)::float/
count(*)

-

sum(
case when r.team_score>r.opponent_score and r.field='offense_home' then 1
     when r.team_score<r.opponent_score and r.field='defense_home' then 1
     when r.field='none' then 0.5
     else 0 end)::float/
--sum(
--case when r.field in ('offense_home','defense_home') then 1
--     else 0
--end)
count(*)
)::numeric(4,3) as diff,
count(*)
from ncaa.results r
join ncaa._schedule_factors t
  on (t.year,t.school_id)=(r.year,r.school_id)
join ncaa._schedule_factors o
  on (o.year,o.school_id)=(r.year,r.opponent_id)
join ncaa._factors f
  on (f.parameter,f.level)=('field',r.field)
where

TRUE

-- each game once

and r.school_id > r.opponent_id

-- test November and December

and extract(month from r.game_date) in (11,12)

-- D1

--and r.team_div_id=1
--and r.opponent_div_id=1
;