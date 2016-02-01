create extension if not exists plpython3u;

drop function if exists skellam2(float, float, float, integer, text);

create or replace function skellam2
  (mu1 float, mu2 float, ft float, up integer, outcome text, OUT p float)
returns float
as $$

from scipy.stats import skellam

if (outcome=="draw"):
   p = skellam.pmf(-up, mu1*ft, mu2*ft)
elif (outcome == "lose"):
   p = skellam.cdf(-1-up, mu1*ft, mu2*ft)
else:
   p = skellam.cdf(-1+up, mu2*ft, mu1*ft)

return(p)

$$ language plpython3u;
