include("01ukp_v1.jl")
include("01ukp_v2.jl")

#continuous relaxation z(C(MKP)) = surrogate relaxation z(S(MKP)) using Dantzig bound
function relax_linear_bound(p,w,c)
    c_total = sum(c)
    z_C_MKP, x_glouton, z_glouton = calcul_limit(p,w,c_total,0)
    return z_C_MKP
end

#surrogate relaxation z(S(MKP)) using Martello and Toth bound
function relax_surrogate_bound(p,w,c)
    c_total = sum(c)
    z_S_MKP, x_glouton, z_glouton = calcul_limit_v2(p,w,c_total,0)
    return z_S_MKP
end

#calculate feasible solution (lower bound)
function calcul_lower_bound(p,w,c)
    m = length(c)
    n = length(p)
    i, j, lower_bound = 1, 1, 0
    cr_lastKS = 0   #residual capacity of knapsack (i-1)
    cr_i = c[i]     #residual capacity of knapsack i

    while i <= m && j <= n
        if i > 1
            cr_i = c[i] - (w[j] - cr_lastKS)    #step c
            j += 1  #step a
        end
        keep_going = true
        while j <= n && keep_going
            if cr_i - w[j] >= 0
                cr_i -= w[j]
                lower_bound += p[j]
                j += 1
            else
                keep_going = false
            end
        end
        cr_lastKS = cr_i
        i += 1  #step b
    end

    return lower_bound
end