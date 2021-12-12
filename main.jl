include("01ukp_v1.jl")
include("01ukp_v2.jl")
include("m01kp.jl")

function main()
    p=[4,9,10,9,3,14,14,2]
    w=[1,3,4,4,2,13,17,3]
    c=[17,12]
    p,w = renumerotation(p,w)
    println(p)
    println(w)
    #x1,z1 = resolution(p,w,C)       #Dantzig
    #x2,z2 = resolution_v2(p,w,C)    #Martello et Toth
    println(relax_linear_bound(p,w,c))
end

main()