# --------------------------------------------------------------------------- #
# collect the un-hidden filenames available in a given folder

function getfname(pathtofolder)

    # recupere tous les fichiers se trouvant dans le repertoire cible
    allfiles = readdir(pathtofolder)

    # vecteur booleen qui marque les noms de fichiers valides
    flag = trues(size(allfiles))

    k=1
    for f in allfiles
        # traite chaque fichier du repertoire
        if f[1] == '.'
            # fichier cache => supprimer
            flag[k] = false
        end
        k = k+1
    end

    # extrait les noms valides et retourne le vecteur correspondant
    finstances = allfiles[flag]
    return finstances
end

# --------------------------------------------------------------------------- #
# loading an instance

function load(fname)
    f=open(fname)
    # Read the vector of capacity of knapsacks
    c = parse.(Int, split(readline(f)) )
    # Read the vector of profit of items
    p = parse.(Int, split(readline(f)) )
    # Read the vector of weight of items
    w = parse.(Int, split(readline(f)) )
    close(f)
    return p, w, c
end