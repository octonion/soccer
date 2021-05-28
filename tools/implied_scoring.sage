from scipy.stats import poisson
from scipy.stats import skellam
from scipy import optimize

from math import floor, ceil

from sys import argv

win = 1/float(argv[1])
draw = 1/float(argv[2])
lose = 1/float(argv[3])

print("Implied:")
print()
print("  Pr(win) = {}".format(win))
print("  Pr(draw) = {}".format(draw))
print("  Pr(lose) = {}".format(lose))
print()

m_s = win+draw+lose
m_win = win/m_s
m_draw = draw/m_s
m_lose = lose/m_s

f = lambda p: (skellam.pmf(0, p[0], p[1]) - m_draw)^2 + (skellam.cdf(-1, p[0], p[1]) - m_lose)^2

c_1 = lambda p: p[0]
c_2 = lambda p: p[1]

solution = minimize_constrained(f, [c_1, c_2], [2, 2])

(mu1, mu2) = solution

print("Multiplicative method:")
print()
print("  Derived expected goals:")
print("    mu1 = {}, mu2 = {}".format(mu1,mu2))
print()

# Power

# Solve for k: win^k + draw^k + lose^k = 1

k = find_root(win^x + draw^x + lose^x - 1, 1, 2)

print("Power method:")
print()
print("  k = {}".format(k))

p_win = win^k
p_draw = draw^k
p_lose = lose^k

f = lambda p: (skellam.pmf(0, p[0], p[1]) - p_draw)^2 + (skellam.cdf(-1, p[0], p[1]) - p_lose)^2

c_1 = lambda p: p[0]
c_2 = lambda p: p[1]

solution = minimize_constrained(f, [c_1, c_2], [2, 2])

(mu1, mu2) = solution

print("  Derived expected goals:")
print("    mu1 = {}, mu2 = {}".format(mu1,mu2))
print()
