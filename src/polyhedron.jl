const INF = 1.0e9
const EPS = 1.0e-9
const BIAS = EPS * [ 0.09816024370339371,  0.6196549438024468,  0.9755418207471769]

"""
Determine whether a point lies inside a 3D polyhedron. Return 1 if inside, 0 if outside, -1 if exactly on the edge. 

`pinpoly(nodes::Vector{NTuple{3, Real}}, faces::Vector{NTuple{3,Int}}, point::NTuple{3, Real})`

`nodes`: Vector of the node positions of the polyhedron.

`faces`: Vector of the triangular faces on the boundary.
 
`point`: Position of the point.

This algorithm was proposed by W. Randolph Franklin: https://wrf.ecse.rpi.edu//Research/Short_Notes/pnpoly.html.
"""  
function pinpoly(nodes::Vector{Vector{Float64}}, faces::Vector{NTuple{3,Int}}, point::NTuple{3, Float64})
    c = 0
    for face in faces
        cross = pcrossface(nodes[face[1]], nodes[face[2]], nodes[face[3]], point)
        if cross == -1
            return -1
        end
        if cross == 1
            c = 1 - c
        end
    end
    return c
end

function pcrossface(node1::Vector{Float64}, node2::Vector{Float64}, node3::Vector{Float64}, point::NTuple{3, Float64})
    e1 = node2 - node1
    e2 = node3 - node1

    O = collect(point)
    D = Float64[INF, 0., 0.]

    P = cross_product(D, e2)

    det = e1' * P
    # If the determinant is near zero, the ray lies in the plane of the triangle.
    if abs(det) == 0.0
        # 已知射线在三角形平面内。
        # Determine if the point is in the triangle.
        if pintriangle(node1, node2, node3, point) != 0
            return -1
        end
        return 0
    end
    inv_det = 1.0 / det

    T = O - node1
    u = T' * P * inv_det
    if u < 0.0 || u > 1.0
        return 0
    end

    Q = cross_product(T, e1)
    v = D' * Q * inv_det
    if v < 0.0 || u + v > 1.0
        return 0
    end

    # 已知射线与三角形平面的交点不在三角形外。
    t = e2' * Q * inv_det
    if abs(t) == 0.0
        return -1
    end

    # 已知射线与三角形平面的交点不在三角形外，且射线起点不在三角形平面内。
    if u == 0.0 || v == 0.0 || u+v == 1.0
        return pcrossface(node1, node2, node3, point + BIAS)
    end

    # 已知射线与三角形平面的交点在三角形内（不包括边上），且射线起点不在三角形平面内。
    return 1     
end

function pintriangle(A::Vector{Float64}, B::Vector{Float64}, C::Vector{Float64}, point::NTuple{3, Float64})
    P = collect(point)
    PA = P - A
    PB = P - B
    PC = P - C

    t1 = sign(cross_product(PA, PB))
    t2 = sign(cross_product(PB, PC))
    t3 = sign(cross_product(PC, PA))

    if t1==t2 && t2==t3
        return 1
    else
        return 0
    end
end