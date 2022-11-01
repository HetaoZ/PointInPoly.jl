const D = [0.919416, 0., 0.] .* 1e8  # 限制在一个内
# const D = [0.919416, 0.014372, 0.] .* 1e8  # 限制在一个平面内
# const D = [1.0e10, 0.45919416e-10, 0.51437296e-10]


"""
Determine if a point lies inside a 1D segment/2D polygon/3D polyhedron. Return 1 if inside, 0 if outside, -1 if exactly on any face. 

    pinpoly(point::NTuple{dim,Float64}, faces::NTuple{N,NTuple{dim,NTuple{dim,Float64}}}, start::NTuple{dim,Float64}, stop::NTuple{dim,Float64}) where N where dim

`faces`: Tuples of the node position of all `face`s on the boundary. A `face` is referred to a node/segment/triangle in 1/2/3D space. The arrangement order of nodes, clockwise or anti-clockwise, doesn't matter.

`point`: Position of the point.

`start`: The minimum coordinates among all nodes

`stop`: The maximum coordinates among all nodes

Example:

```
P = (
    (0., 0., 0.),
    (1., 0., 0.),
    (0., 1., 0.),
    (0., 0., 1.)
    )
faces = (
    (P[1], P[2], P[3]), 
    (P[1], P[2], P[4]), 
    (P[2], P[3], P[4]), 
    (P[1], P[3], P[4])
    )
start = (0., 0., 0.)
stop = (1., 1., 1.)

points = (
    ( 0.1,  0.1,  0.01), 
    ( 0.1,  0.1,    0.), 
    ( 0.1,  0.1,  -0.1), 
    (  0.,   0.,   0.5), 
    (  0.,  0.1,   0.1), 
    (  0.,   0.,   1.1),
    ( 1/4,  1/4,   1/2),
    )

for point in points
    println(point," => ", pinpoly(point, faces, start, stop))
end
```

References

[1] https://wrf.ecse.rpi.edu//Research/Short_Notes/pnpoly.html.

[2] https://blog.csdn.net/u012138730/article/details/80235813

"""  
function pinpoly(point::NTuple{dim,T}, faces::NTuple{N,NTuple{dim,NTuple{dim,T}}}, start::NTuple{dim,T}, stop::NTuple{dim,T}) where {dim,N} where T<:Real
    if dim == 1
        return pinsegment(point[1], start[1], stop[1])
    else
        c = 0
        if betweeneq(point, start, stop)
            for face in faces
                # ray starting from +∞ and stoping at the point
                intersection = ray_intersect_face(point, face...)
                if intersection == 1  # face and the ray are intersected
                    c = 1 - c
                else
                    if intersection == -1  # point just in face
                        return -1
                    end
                end
            end
        end
        return c
    end
end

"1D intersection, return 1: intersected, 0: not intersected, -1: point just in face"
function pinsegment(point::T, start::T, stop::T) where T <: Real
    if start < point < stop
        return 1
    elseif point == start || point == stop
        return -1
    else
        return 0
    end
end

"2D intersection, return 1: intersected, 0: not intersected, -1: point just in face"
function ray_intersect_face(X, P1, P2)
    # ⊻ : \xor
    if (X[1] - P1[1]) * (P2[2] - P1[2]) == (X[2] - P1[2]) * (P2[1] - P1[1]) && min(P1[1], P2[1]) <= X[1] <= max(P1[1], P2[1])
        return -1
    else
        point_inside = ( (P1[2] > X[2]) ⊻ (P2[2] > X[2] ) ) &&  X[1] < (P2[1] - P1[1]) * (X[2] - P1[2]) / (P2[2] - P1[2]) + P1[1]  
        return point_inside ? 1 : 0
    end
end

"3D intersection, return 1: intersected, 0: not intersected, -1: point just in face"
function ray_intersect_face(point, a, b, c)
    point, a, b, c = collect.((point, a, b, c))
    normal = normalize(cross( b .- a, c .- a ))
    return segment_intersect_face(point, point .+ D, a, b, c, normal)
end

"[@ref] https://blog.csdn.net/u012138730/article/details/80235813"
function segment_intersect_face(p, q, a, b, c, normal)

    # check y and z coordinates
    y = [a[2],b[2],c[2]]
    z = [a[3],b[3],c[3]]
    if !(minimum(y) ≤ p[2] ≤ maximum(y) &&  minimum(z) ≤ p[3] ≤ maximum(z))
        return 0
    end

    qp = p .- q  # p = point
    Δ = dot(qp, normal)
    if Δ == 0.
        ap = p .- a
        t = dot(ap, normal)
        if t == 0.
            M = hcat(b .- a, c .- a, normal)
            λ = M \ ap
            return (0. ≤ λ[1] && 0. ≤ λ[2] && (λ[1] + λ[2]) ≤ 1. ) ? -1 : 0
        else
            return 0
        end
    else
        ap = p .- a
        t = dot(ap, normal) / Δ
        if t == 0.
            return -1
        elseif 0. < t ≤ 1.0
            ab = b .- a
            ac = c .- a
            m = mixed_product(qp,ab,ac)
            λ2 = mixed_product(ac,qp,ap)/m
            λ3 = mixed_product(-ab,qp,ap)/m
            return (0. ≤ λ2  && 0. ≤ λ3  && λ2 + λ3 ≤ 1.) ? 1 : 0
        else
            return 0
        end
    end
end

"Mixed product of three 3-vectors (a, b, c) = dot(a, cross(b,c)) where dot() and cross() are imported from LinearAlgebra"
@inline function mixed_product(a::Vector{T},b::Vector{T},c::Vector{T}) where T <: Real
    return dot(a, cross(b, c))
end

@inline function betweeneq(a::NTuple{dim,T}, lo::NTuple{dim,T}, hi::NTuple{dim,T}) where dim where T <: Real
    return all(lo .≤ a .≤ hi)
end