include("01ukp_v1.jl")
include("01ukp_v2.jl")
include("m01kp.jl")

function main()
    p=[110,150,70,80,30,5]
    w=[40,60,30,40,20,5]
    c=[65,85]
    p,w = renumerotation(p,w)
    println(p)
    println(w)
    #x1,z1 = resolution(p,w,C)       #Dantzig
    #x2,z2 = resolution_v2(p,w,C)    #Martello et Toth
    println(relax_linear_bound(p,w,c))
    println(relax_surrogate_bound(p,w,c))
end

main()