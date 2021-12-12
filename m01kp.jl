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