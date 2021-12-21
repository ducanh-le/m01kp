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

#arrange the items in decreasing order of their profit (p/w) and arrange the knapsacks in increasing order of their capacities (c)
function renumerotation_v2(p,w,c)
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
    m = length(c)
    sort!(c)
    return p,w,c
end

#bound and bound algorithm for M01KP (Martello & Toth)
function bound_and_bound(p,w,c)
    n = length(p)
    m = length(c)
    x_history = Array{Int,2}(undef,m,n); fill!(x_history,0) #matrix whose rows give the solutions found in the last application of lower_bound
    b = Array{Int,1}(undef,n); fill!(b,1)  #value = 1 if item wasn't inserted in knapsacks 1..i, 0 otherwise
    k = copy(c)   #available capacities of each knapsacks
    x_current = Array{Int,2}(undef,m-1,n); fill!(x_current,0) #current solution
    S = Array{Int,2}(undef,m-1,n); fill!(S,0) # S[q,j] pointer to the item inserted in knapsack q just before item j
    S0 = Array{Int,1}(undef,m-1); fill!(S0,-1) #pointer to the last item inserted in knapsack q; S0[q] = -1 if q is empty
    z_best = z_current = 0
    i = 1
    upper = upper_bound(p,w,c,i,k,b,z_current)

end

#solve the current relaxation surrogate problem to find the upper bound
function upper_bound(p,w,c,i,k,b,z_current)
    p_prime = Int[]
    w_prime = Int[]
    for j in 1:n
        if b[j] == 1    #item wasn't inserted in any knapsacks
            append!(p_prime,p[j])
            append!(w_prime,w[j])
        end
    end
    c_new = k[i] + sum(c[j] for j in i+1:length(c))
    x_prime, z_prime = resolution_v2(p_prime,w_prime,c_new)
    return z_current + z_prime
end

#glouton heuristic to find the lower bound
function lower_bound(p,w,i,k,b,z_current,S,x_history)
    m = length(k); n = length(b)
#create N'
    p_prime, w_prime, index_prime = Int[], Int[], Int[]
    for j in 1:n
        if b[j] == 1    #item wasn't inserted in any knapsacks
            append!(p_prime,p[j])
            append!(w_prime,w[j])
            append!(index_prime,j)   #original index item for N'
        end
    end
#create N_u
    p_u, w_u, index_u = Int[], Int[], Int[]
    for j in 1:length(index_prime)
        if S[i,index_prime[j]] == 0
            append!(p_u,p_prime[j])
            append!(w_u,w_prime[j])
            append!(index_u,index_prime[j])   #original index item for N_u
        end
    end

    u = i
    keep_going = true
    while keep_going
    #fix all item which can't be inserted in knapsack u to 0
        all_item = 1:n
        not_u_item = setdiff(all_item, index_u)
        for j in not_u_item
            x_history[u,j] = 0
        end
    #fill this knapsack u
        if length(index_u) != 0
            x_u, z_u = resolution_v2(p_u,w_u,k[u])
            for j in 1:length(x_u)
                x_history[u,index_u[j]] = x_u[j]
            end
            z_current += z_u
        end
    
        if (u == m)
            return z_current
        else
        #update N'
            for j in index_u
                if x_history[u,j] == 1
                    setdiff!(index_prime,j)
                end
            end
            p_prime, w_prime = Int[], Int[]
            for j in index_prime
                append!(p_prime,p[j])
                append!(w_prime,w[j])
            end
        #update N_u
            p_u = copy(p_prime)
            w_u = copy(w_prime)
        
            u += 1
        end
    end
end