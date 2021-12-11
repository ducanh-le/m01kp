include("01ukp_v1.jl")
include("01ukp_v2.jl")

function main()
    p=[4,9,10,9,3,14,14,2]
    w=[1,3,4,4,2,13,17,3]
    C=22
    p,w = renumerotation(p,w)
    x1,z1 = resolution(p,w,C)       #Dantzig
    x2,z2 = resolution_v2(p,w,C)    #Martello et Toth
end

main()