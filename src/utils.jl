function cross_product(a::Vector{T} where T <: Real, b::Vector{T} where T <: Real)
    l = (length(a), length(b))
    if l == (3, 3)
        return cross(a,b) 
    elseif l == (2, 2)
        return eltype(a)[0,0,a[1]*b[2]-b[1]*a[2]]
    else
        error("undef dim")
    end
end

function betweeneq(p::NTuple{3,Float64}, point1::NTuple{3,Float64}, point2::NTuple{3,Float64})
    ans = true
    for i = 1:3
        if !(point1[i] <= p[i] <= point2[i])
            ans = false
            break
        end
    end
    return ans
end

function between(p::NTuple{3,Float64}, point1::NTuple{3,Float64}, point2::NTuple{3,Float64})
    ans = true
    for i = 1:3
        if !(point1[i] < p[i] < point2[i])
            ans = false
            break
        end
    end
    return ans
end