function cross_product(a::Vector{T} where T <: Number, b::Vector{T} where T <: Number)
    if (length(a), length(b)) == (3, 3)
        return eltype(a)[a[2]*b[3]-b[2]*a[3], a[3]*b[1]-a[1]*b[3], a[1]*b[2]-b[1]*a[2]] 
    elseif (length(a), length(b)) == (2, 2)
        return eltype(a)[0,0,a[1]*b[2]-b[1]*a[2]]
    else
        error("undef dim")
    end
end
