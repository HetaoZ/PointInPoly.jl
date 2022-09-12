"""
Determine if a point lies inside a 1D segment/2D polygon/3D polyhedron. Return 1 if inside, 0 if outside, -1 if exactly on any face. 

    pinpoly(point::NTuple{dim,Float64}, faces::NTuple{N,NTuple{dim,NTuple{dim,Float64}}}, start::NTuple{dim,Float64}, stop::NTuple{dim,Float64}) where N where dim

`faces`: Tuples of the node position of all `face`s on the boundary. A `face` is referred to a node/segment/triangle in 1/2/3D space, and its normal vector must be outward.

`point`: Position of the point.

`start`: The minimum coordinates among all nodes

`stop`: The maximum coordinates among all nodes

This algorithm was proposed by W. Randolph Franklin: https://wrf.ecse.rpi.edu//Research/Short_Notes/pnpoly.html.
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

function pinsegment(point::Float64, start::Float64, stop::Float64)
    if start < point < stop
        return 1
    elseif point == start || point == stop
        return -1
    else
        return 0
    end
end

"return 1: intersected, 0: not intersected, -1: point just in face"
function ray_intersect_face(X::NTuple{2,Float64}, P1::NTuple{2,Float64}, P2::NTuple{2,Float64})
    # ⊻ : \xor
    if (X[1] - P1[1]) * (P2[2] - P1[2]) == (X[2] - P1[2]) * (P2[1] - P1[1]) && min(P1[1], P2[1]) <= X[1] <= max(P1[1], P2[1])
        return -1
    else
        point_inside = ( (P1[2] > X[2]) ⊻ (P2[2] > X[2] ) ) &&  X[1] < (P2[1] - P1[1]) * (X[2] - P1[2]) / (P2[2] - P1[2]) + P1[1]  
        return point_inside ? 1 : 0
    end
end

const INF = 1.0e9
const EPS = 1.0e-9
const BIAS = EPS * [ 0.09816024370339371,  0.6196549438024468,  0.9755418207471769]

"return 1: intersected, 0: not intersected, -1: point just in face"
function ray_intersect_face(point::NTuple{3, Float64}, nodeA::NTuple{3, Float64}, nodeB::NTuple{3, Float64}, nodeC::NTuple{3, Float64})

    if face_beyond_box_of_ray(point, nodeA, nodeB, nodeC)
        return 0
    end

    node1 = collect(nodeA)
    node2 = collect(nodeB)
    node3 = collect(nodeC)
    O = collect(point)

    e1 = node2 - node1
    e2 = node3 - node1

    D = Float64[INF, 0., 0.]

    P = cross(D, e2)

    det = e1' * P
    # If the determinant is near zero, the ray lies parallel to the plane of the triangle.
    if abs(det) == 0.0
        # 已知射线与三角形共面，即参数t无穷大。
        # Determine if the point is in the triangle.
        # if pintriangle(node1, node2, node3, point) != 0
        #     return -1
        # end
        
        return 0
    end
    inv_det = 1.0 / det

    T = O - node1
    u = T' * P * inv_det
    if u < 0.0 || u > 1.0
        return 0
    end

    Q = cross(T, e1)
    v = D' * Q * inv_det
    if v < 0.0 || u + v > 1.0
        return 0
    end

    # 已知射线与三角形平面的交点不在三角形外。
    t = e2' * Q * inv_det
    #注意射线是单向的，排除反向相交情况。
    if t < 0.
        return 0
    end
    if t == 0.
        return -1
    end

    # 已知射线与三角形平面的交点不在三角形外，且射线起点不在三角形平面内。
    if u == 0.0 || v == 0.0 || u+v == 1.0
        return pinside(point .+ BIAS, nodeA, nodeB, nodeC)
    end

    # 已知射线与三角形平面的交点在三角形内（不包括边上），且射线起点不在三角形平面内。
    return 1     
end

function face_beyond_box_of_ray(point::NTuple{3, Float64}, nodeA::NTuple{3, Float64}, nodeB::NTuple{3, Float64}, nodeC::NTuple{3, Float64}) 

    Y = minimum((nodeA[2], nodeB[2], nodeC[2])) <= point[2] <= maximum((nodeA[2], nodeB[2], nodeC[2]))

    Z = minimum((nodeA[3], nodeB[3], nodeC[3])) <= point[3] <= maximum((nodeA[3], nodeB[3], nodeC[3]))

    return !(Y && Z)
end

@inline function betweeneq(a::NTuple{dim,T}, lo::NTuple{dim,T}, hi::NTuple{dim,T}) where dim where T <: Real
    return all(lo .≤ a .≤ hi)
end