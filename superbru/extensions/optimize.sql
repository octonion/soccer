create extension if not exists plpython3u;

drop function if exists optimize(float, float);

create or replace function optimize
  (mu1 float, mu2 float, OUT outcome integer[])
returns integer[]
as $$

from math import floor, ceil
from scipy.stats import skellam
from scipy.stats import poisson

outcome = [round(mu1), round(mu2)]
e_score = 0.0

for i in range(max(0,floor(mu1)-1),ceil(mu1)+1):
    e = 0.0
    for j in range(max(0,floor(mu2)-1),ceil(mu2)+1):

        if (i==j):

            # Right result
            e = skellam.pmf(0, mu1, mu2)
            
            # Bonus for Exact
            e += 2*poisson.pmf(i, mu1, 0)*poisson.pmf(j, mu2, 0)

            # Bonus for Close
            e += 0.5*poisson.pmf(i+1, mu1, 0)*poisson.pmf(j+1, mu2, 0)
            if i>0:
                e += 0.5*poisson.pmf(i-1, mu1, 0)*poisson.pmf(j-1, mu2, 0)
                
        elif (i<j):

            # Right result
            e = skellam.cdf(-1, mu1, mu2)

            # Bonus for Exact
            e += 2*poisson.pmf(i, mu1, 0)*poisson.pmf(j, mu2, 0)

            # Bonus for Close
            e += 0.5*poisson.pmf(i+1, mu1, 0)*poisson.pmf(j+1, mu2, 0)
            e += 0.5*poisson.pmf(i, mu1, 0)*poisson.pmf(j+1, mu2, 0)
            if i>0:
                e += 0.5*poisson.pmf(i-1, mu1, 0)*poisson.pmf(j-1, mu2, 0)
                e += 0.5*poisson.pmf(i-1, mu1, 0)*poisson.pmf(j, mu2, 0)
            if j>i+1:
                e += 0.5*poisson.pmf(i, mu1, 0)*poisson.pmf(j-1, mu2, 0)
                e += 0.5*poisson.pmf(i+1, mu1, 0)*poisson.pmf(j, mu2, 0)
		
        elif (j<i):

            # Right result
            e = skellam.cdf(-1, mu2, mu1)

            # Bonus for Exact
            e += 2*poisson.pmf(i, mu1, 0)*poisson.pmf(j, mu2, 0)

            # Bonus for Close
            e += 0.5*poisson.pmf(i+1, mu1, 0)*poisson.pmf(j+1, mu2, 0)
            e += 0.5*poisson.pmf(i+1, mu1, 0)*poisson.pmf(j, mu2, 0)
            if j>0:
                e += 0.5*poisson.pmf(i-1, mu1, 0)*poisson.pmf(j-1, mu2, 0)
                e += 0.5*poisson.pmf(i, mu1, 0)*poisson.pmf(j-1, mu2, 0)
            if i>j+1:
                e += 0.5*poisson.pmf(i-1, mu1, 0)*poisson.pmf(j, mu2, 0)
                e += 0.5*poisson.pmf(i, mu1, 0)*poisson.pmf(j+1, mu2, 0)
        if e>e_score:
            outcome = [i,j]
            e_score = e

return(outcome)

$$ language plpython3u;
