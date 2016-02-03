select npl.parameter,npl.type,npl.level,nbf.estimate
from club._parameter_levels npl
left outer join club._basic_factors nbf
  on (nbf.factor,nbf.level,nbf.type)=(npl.parameter,npl.level,npl.type)
where npl.type='random'
order by parameter,level;
