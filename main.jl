include("01ukp_v1.jl")
include("01ukp_v2.jl")
include("m01kp.jl")
include("load_instance.jl")

function main()
    println("Etudiant(e)s : LE et HALIMI")
    dat_folder = "instance"
    files      = getfname(dat_folder)
    io = open("resultat", "w")
    for instance = 1:length(files)
        p,w,c = load(string(dat_folder,"/",files[instance]))
        p,w = renumerotation(p,w)
        println(io, files[instance], " : ")
        println(io, "c = ", c)
        println(io, "p = ", p)
        println(io, "w = ", w)
        rlb = relax_linear_bound(p,w,c)
        rsb = relax_surrogate_bound(p,w,c)
        lb  = calcul_lower_bound(p,w,c)
        println(io, "linear bound = ", rlb, " | surrogate bound = ", rsb, " | lower bound = ", lb)
        println(io)
    end
    close(io)
end

main()