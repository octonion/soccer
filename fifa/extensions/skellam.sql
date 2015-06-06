
create extension if not exists plpython2u;

drop function if exists skellam(float, float, text);

create or replace function skellam
  (mu1 float, mu2 float, outcome text, OUT p float)
returns float
as $$

from scipy.stats import skellam

if (outcome=="tie"):
   p = skellam.pmf(0, mu1, mu2)
elif (outcome == "lose"):
   p = skellam.cdf(-1, mu1, mu2)
else:
   p = skellam.cdf(-1, mu2, mu1)

return(p)

$$ language plpython2u;
