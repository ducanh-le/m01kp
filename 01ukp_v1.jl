#renumeroter les indices dans p et w à l'ordre decroissant de profit
function renumerotation(p,w)
    n = length(p)
    mem = Array{Tuple{Int,Int},1}(undef,n)
    for i in 1:n
        mem[i] = (p[i],w[i])
    end
    sort!(mem, by = x -> x[1]/x[2], rev = true)
    for i in 1:n
        p[i] = mem[i][1]
        w[i] = mem[i][2]
    end
    return p,w
end

#resoluer le probleme
function resolution(p,w,C)
    xBest = zeros(Int64,length(p))
    lim_total, xBest, zBest = calcul_limit(p,w,C,xBest,0)
    println("Problem's limit by Dantzig is ",lim_total)
    println("xInit = ",xBest," with zBest = ",zBest)
    xBest, zBest = branch_and_bound(p,w,C,0,xBest,zBest,lim_total)
    return xBest, zBest
end

#performer l'algorithme branch_and_bound
function branch_and_bound(p,w,C,i_branch,xBefore,zBest,lim_total)
    ind_equal_one = findall(isequal(1),xBefore)
    i_branch_next = filter(x -> x > i_branch,ind_equal_one)
    sort!(i_branch_next, rev = true)
    xBest = xBefore

    for k in i_branch_next
        xCurrent = copy(xBefore)
        xCurrent[k] = 0
        lim_current, xCurrent, zCurrent = calcul_limit(p,w,C,xCurrent,k)
        println("Branch and Bound, i_branch = ",k,", branch's limit by Dantzig is ",lim_current," trouver z = ",zCurrent," avec x = ",xCurrent)

        if lim_current > zBest
            if zCurrent > zBest
                if zCurrent == lim_total
                    println("Found z = ",zCurrent," at problem's limit with x = ",xCurrent," !")
                    return xCurrent, zCurrent
                elseif lim_current > zCurrent
                    xBest, zBest = branch_and_bound(p,w,C,k,xCurrent,zCurrent,lim_total)
                else
                    zBest = zCurrent
                    xBest = copy(xCurrent)
                end
            else
                xBest, zBest = branch_and_bound(p,w,C,k,xCurrent,zBest,lim_total)
            end
        end
    end

    return xBest, zBest
end

#calculer borne Dantzig et solution glouton à partir d'indice i_branch (exclu : x[k] = 1 à partir de k = i_branch + 1)
#pour la borne total, on met i_branch = 0
#retourner borne Dantzig, x et z glouton
function calcul_limit(p,w,C,xBefore,i_branch)
    sum_p, sum_w = 0, 0
    xGlouton = zeros(Int, length(p))

    #traiter la première partie de x (k dans 1..i_branch)
    if i_branch != 0
        firstpart_x = xBefore[1:i_branch]
        ind_equal_one = findall(isequal(1),firstpart_x)
        for k in ind_equal_one
            sum_p = sum_p + p[k]
            sum_w = sum_w + w[k]
            xGlouton[k] = 1
        end
    end

    #traiter la seconde partie de x à s-1
    k, keep_going = i_branch + 1, true
    while k <= length(p) && keep_going
        if sum_w + w[k] <= C
            sum_p = sum_p + p[k]
            sum_w = sum_w + w[k]
            xGlouton[k] = 1
            k = k + 1
        else
            keep_going = false
        end
    end

    #borne Dantzig
    if k <= length(p)
        lim = sum_p + (p[k] / w[k]) * (C - sum_w)
        lim = round(Int,lim,RoundDown)
    else
        lim = sum_p
    end

    #chercher xGlouton
    k = k + 1
    while k <= length(p)
        if sum_w + w[k] <= C
            sum_p = sum_p + p[k]
            sum_w = sum_w + w[k]
            xGlouton[k] = 1
        end
        k = k + 1
    end

    return lim, xGlouton, sum_p
end