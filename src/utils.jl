function cross_product(a::Vector{T} where T <: Number, b::Vector{T} where T <: Number)
    if (length(a), length(b)) == (3, 3)
        return eltype(a)[a[2]*b[3]-b[2]*a[3], a[3]*b[1]-a[1]*b[3], a[1]*b[2]-b[1]*a[2]] 
    elseif (length(a), length(b)) == (2, 2)
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