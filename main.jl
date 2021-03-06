include("01ukp_v1.jl")
include("01ukp_v2.jl")
include("m01kp.jl")
include("load_instance.jl")

function main()
    println("Etudiant(e)s : LE et HALIMI")
    dat_folder = "instance_tp2"
    files      = getfname(dat_folder)
    io = open("resultat", "w")
    for instance = 1:length(files)
        println("Data file : ",files[instance])
        p,w,c = load(string(dat_folder,"/",files[instance]))
        p,w,c = renumerotation_v2(p,w,c)
        println(io, files[instance], " : ")
        println(io, "c = ", c)
        println(io, "p = ", p)
        println(io, "w = ", w)
        dantzig = resolution(p,w,c[1])
        mt = resolution_v2(p,w,c[1])
        #rlb = relax_linear_bound(p,w,c)
        #rsb = relax_surrogate_bound(p,w,c)
        #lb  = calcul_lower_bound(p,w,c)
        #println(io, "linear bound = ", rlb, " | surrogate bound = ", rsb, " | lower bound = ", lb)
        println(io, "Branch and bound solution with Dantzig : ", dantzig[2])
        println(io, "Branch and bound solution with Martello & Toth : ", mt[2])
        println(io)
    end
    close(io)
    println("Fini ! Les résultats sont écrits dans le fichier 'resultat' !")
end

main()