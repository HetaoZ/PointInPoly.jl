const INF = 1.0e10
const EPS = 1.0e-10
const RAN = (0.00006024370339371,  0.196549438024468,  0.4755418207471769)
const BIAS = EPS .* RAN
# const D = INF .* collect(RAN)  # 三维射线的无穷远端
const D = [INF, 0., 0.]
const Dinv = [-INF, 0., 0.]
const D2 = INF .* collect(RAN)


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
function pinpoly(point::NTuple{dim,Float64}, faces::NTuple{N,NTuple{dim,NTuple{dim,Float64}}}, start::NTuple{dim,Float64}, stop::NTuple{dim,Float64}) where N where dim
    
    if dim == 1
        return pinsegment(point[1], start[1], stop[1])
    else
        c = 0
        if betweeneq(point, start, stop)
            for face in faces
                # ray starting from +∞ and stoping at the point
                intersection = ray_intersect_face(point, face...)
                # println(face, " => ", intersection)
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

@inline function betweeneq(a::NTuple{dim,Float64}, lo::NTuple{dim,Float64}, hi::NTuple{dim,Float64}) where dim
    return all(lo .≤ a .≤ hi)
end

"1D intersection, return 1: intersected, 0: not intersected, -1: point just in face"
function pinsegment(point::Float64, start::Float64, stop::Float64)
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
    return segment_intersect_face(point, D, a, b, c, normal)
end

"[@ref] https://blog.csdn.net/u012138730/article/details/80235813"
function segment_intersect_face(p, q, a, b, c, normal)
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
            return (0. ≤ λ2 ≤ 1. && 0. ≤ λ3 ≤ 1.) ? 1 : 0
        else
            return 0
        end
    end
end

"Mixed product of three 3-vectors (a, b, c) = dot(a, cross(b,c)) where dot() and cross() are imported from LinearAlgebra"
@inline function mixed_product(a::Vector{Float64},b::Vector{Float64},c::Vector{Float64})
    return dot(a, cross(b, c))
end