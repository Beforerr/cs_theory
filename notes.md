Ampere's law

$$
\begin{equation}
d B_x / d z 
= \sum_\alpha\left(n_\alpha u_{\alpha y}-\Gamma_\alpha B_y / B_z\right) \
= n u_y-\Gamma_e B_y / B_z
\end{equation}
$$

$$
\begin{equation}
d B_y / d z 
= \sum_\alpha\left(-n_\alpha u_{\alpha x}+\Gamma_\alpha B_x / B_z\right) 
= -n u_x+\Gamma_e B_x / B_z
\end{equation}
$$

Asymptotic conditions

$$
{B_z}^2 = \sum \Gamma_{\alpha}^2/n_{\alpha}(\infty)
$$

## $\Gamma_e \neq 0$

Assuming $n_2 = \alpha_n n_1$ and $u_2 = - u_1$.

We have 

$$
n_e = n_1 + n_2 = (1 + \alpha_n) n_1
\\
\Gamma_e = \Gamma_1 + \Gamma_2 = (1 - \alpha_n) \Gamma_1
$$

The Ampere's law becomes

$$
\begin{equation}
d_z B_x = n_1 u_{1y} + n_2 u_{2y} - \Gamma_e B_y / B_z
    = (1 - \alpha_n) n_1 u_{1y} - \Gamma_e B_y / B_z
\end{equation}
$$

$$
\begin{equation}
d_z B_y = - n_1 u_{1x} - n_2 u_{2x} + \Gamma_e B_x / B_z
    = - (1 - \alpha_n) n_1 u_{1x} + \Gamma_e B_x / B_z
\end{equation}
$$

The momentum equation becomes

$$
\begin{equation}
\Gamma_1 \frac{d u_{1 x}}{d z}=n_1 u_{1 y} B_z-\Gamma_1 B_y
\end{equation}
$$

$$
\begin{equation}
\Gamma_1 \frac{d u_{1 y}}{d z}=\Gamma_1 B_x-n_1 u_{1 x} B_z
\end{equation}
$$

$$
\begin{equation}
\frac{d}{d z}\left(\frac{\Gamma_1^2}{n_1}+\frac{C n_1^\gamma}{2}\right) = {n_1}(u_{1x} B_y-u_{1y} B_x - \frac{T_e}{2n_e} \frac{d n_e}{dz})
\end{equation}
$$

The asymptotic conditions become

$$
{B_z}^2 = \Gamma_1^2/n_1(\infty) + \Gamma_2^2/n_2(\infty) 
= (1+\alpha_n) \Gamma_1^2/n_1(\infty)
$$

### Coding Part

```{mathematica}
(* Define the system of equations *)
γ = 5/3;
zmax = 10;
eps = 0.01;

GammaE := (1 - alphaN) Gamma1;
n2 := alphaN n1[z];
ne := (1 + alphaN) n1[z];
u2x := -u1x[z];
u2y := -u1y[z];

n1Inf = 1 / (1 + alphaN);
Gamma1 := - Bz Sqrt[n1Inf/(1 + alphaN)];

eq1 = D[Bx[z], z] == n1[z] u1y[z] + n2 u2y - GammaE By[z]/Bz;
eq2 = D[By[z], z] == -n1[z] u1x[z] - n2 u2x + GammaE Bx[z]/Bz;
eq3 = Gamma1 D[u1x[z], z] == n1[z] u1y[z] Bz - Gamma1 By[z];
eq4 = Gamma1 D[u1y[z], z] == Gamma1 Bx[z] - n1[z] u1x[z] Bz;
eq5 = D[(Gamma1^2/n1[z] + C n1[z]^γ/2), z] == 
   n1[z] (u1x[z] By[z] - u1y[z] Bx[z] - Te/(2 ne) D[ne, z]);
```

## $\Gamma_e = 0$

### Coding Part

In summary, we have five equations and five unknown $n, B_x, B_y, u_x, u_y$ which depend on $z$.

$$
\begin{equation}
\begin{aligned}
d_z B_y  &= - n u_x
\\
d_z B_x &= n u_y
\\
d_z u_x &= B_y (n - 1)
\\
d_z u_y &= B_x (1 - n)
\\
d_z n &= \frac{n (u_x B_y - u_y B_x)}{(-B_z^2/n^2 + \beta_i \gamma n^{\gamma-1} + T_e)}
\end{aligned}
\end{equation}
$$

And the boundary conditions:

* when $z=0$ :  $B_x =0$
* when $z \to \infty$ : $B_x \to 1, B_y \to a$, $n \to 1$

  * As the derivatives also go to zero we have

    $$
    u_x \to 0
    \\
    u_y \to 0
    $$

Combining the first equation and the third equation, we have

$$
n u_x^2 - (n - 1) B_y^2 = C_1
$$

Using the boundary conditions, we have $C_1 = - (n - 1) a^2$. So

$$
u_x^2 = (n-1)(B_y^2 - a^2) / n
$$

Similarly, combining the second equation and the fourth equation, we have

$$
n u_y^2  + (n-1) B_x^2 = C_2 = (n-1)
$$

$$
u_y^2 = (n - 1) (1 - B_x^2) / n
$$

```{mathematica}
(* Define the system of equations *)
eq1 = D[By[z], z] == -n[z] ux[z];
eq2 = D[Bx[z], z] == n[z] uy[z];
eq3 = D[ux[z], z] == By[z] (n[z] - 1);
eq4 = D[uy[z], z] == Bx[z] (1 - n[z]);
eq5 = D[n[z], z] == (n[z] (ux[z] By[z] - uy[z] Bx[z])) / (- Bz^2/n[z]^2 + betaI gamma n[z]^(gamma - 1));


Bz = 0.1;
ByInfinity = 0.3;
betaI = 1;
gamma = 5/3;

zmax = 10;

(* Boundary conditions *)
bc1 = Bx[0] == 0;
bc2 = n[zmax] == 1;
bc3 = Bx[zmax] == 1;
bc4 = By[zmax] == ByInfinity;
bc5 = ux[zmax] == 0;
bc6 = uy[zmax] == 0;


(* Solve the system numerically *)
sol = NDSolve[{eq1, eq2, eq3, eq4, eq5, bc2, bc3, bc4, bc5, bc6}, {Bx, By, ux, uy, n}, {z, 0, 10}];

(* Plot the solutions *)
Plot[Evaluate[{Bx[z], By[z], ux[z], uy[z], n[z]} /. sol], {z, 0, 10}, PlotLegends -> {"Bx[z]", "By[z]", "ux[z]", "uy[z]", "n[z]"}]
```

```{julia}
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

function bc2a!(resid_a, u, p)
    resid_a[1] = u[2]
    resid_a[2] = u[4] # ux
end

function bc2b!(resid_b, u, p)
    resid_b[1] = u[1]
    resid_b[2] = u[2] - 1
    resid_b[3] = u[3]
    resid_b[4] = u[4]
    resid_b[5] = u[5]
end

span = (0.0, 10.0)
Bz = 0.1
betaI = 1
gamma = 5/3

u0 = [1.3, 0.0, 1.0, 0.0, 1]

bvp = TwoPointBVProblem(system!, (bc2a!, bc2b!), u0, span; bcresid_prototype = (zeros(2), zeros(5)))
sol2 = solve(bvp, MIRK4(), dt = 0.05)
```