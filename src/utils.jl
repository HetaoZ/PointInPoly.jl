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

@inline function betweeneq(a::Vector{T}, lo::Vector{T}, hi::Vector{T}) where T <: Real
    return all(lo .≤ a .≤ hi)
end

@inline function between(a::Vector{T}, lo::Vector{T}, hi::Vector{T}) where T <: Real
    return all(lo .< a .< hi)
end