from scipy.stats import skellam
from scipy import optimize

# Turkey vs Italy, Euros 2020
# Oddschecker odds, May 27 2021

win = 1/8
draw = 1/4
lose = 7/11

s = win+draw+lose
win = win/s
draw = draw/s
lose = lose/s

f = lambda p: (skellam.pmf(0, p[0], p[1]) - draw)^2 + (skellam.cdf(-1, p[0], p[1]) - lose)^2

c_1 = lambda p: p[0]
c_2 = lambda p: p[1]

solution = minimize_constrained(f, [c_1, c_2], [2, 3])
print(solution)
