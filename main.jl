using BoundaryValueDiffEq
using DifferentialEquations

function system!(du, u, p, t)
    n, Bx, By, ux, uy = u
    dBy = -n * ux
    dBx = n * uy
    dux = By * (n - 1)
    duy = Bx * (1 - n)
    dn = n * (ux * By - uy * Bx) / (- Bz^2/n^2 + betaI * gamma * n^(gamma - 1))
    du .= [dn, dBx, dBy, dux, duy]
end

function bc2a!(resid_a, u, p, t)
    resid_a[2] = u[2] 
end

function bc2b!(resid_b, u, p, t)
    resid_b[1] = u[1]
    resid_b[2] = u[2] - 1
    resid_b[3] = u[3]
    resid_b[4] = u[4]
    resid_b[5] = u[5]
end

span = (0.0, 10.0)
u0 = [1.5, 0.0, 1, 0.0, 1]

bvp = TwoPointBVProblem(system!, (bc2a!, bc2b!), u0, span;)