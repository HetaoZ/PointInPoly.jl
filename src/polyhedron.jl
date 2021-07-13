const INF = 1.0e9
const EPS = 1.0e-9
const BIAS = EPS * [ 0.09816024370339371,  0.6196549438024468,  0.9755418207471769]

@inline function cross_product(a::NTuple{3,Float64}, b::NTuple{3,Float64})
    return Float64[a[2]*b[3]-b[2]*a[3], a[3]*b[1]-a[1]*b[3], a[1]*b[2]-b[1]*a[2]] 
end



"""
Determine whether a point lies inside a 3D polyhedron. Return 1 if inside, 0 if outside or exactly on the boundary. 

`pinpoly(node_x::NTuple{N,Float64}, node_y::NTuple{N,Float64}, node_z::NTuple{N,Float64}, faces::NTuple{N,NTuple{3,Int}}, point::NTuple{3, Float64}) where N`

`nodes_x/y/z`: Vectors of the node positions of the polyhedron.

`faces`: Vector of the node numbers of the triangular faces on the boundary.
 
`point`: Position of the point.

This algorithm was proposed by W. Randolph Franklin: https://wrf.ecse.rpi.edu//Research/Short_Notes/pnpoly.html.
"""  
function pinpoly(node_x::NTuple{N,Float64}, node_y::NTuple{N,Float64}, node_z::NTuple{N,Float64}, faces::NTuple{M,NTuple{3,Int}}, point::NTuple{3, Float64}) where N where M
    # Check if the point is out of the bounding box.
    if !between(point, (minimum(node_x), minimum(node_y), minimum(node_z)), (maximum(node_x), maximum(node_y), maximum(node_z)))
        return 0
    end

    c = 0
    for i in eachindex(faces)
        face = faces[i]
        cross = pcrossface(
            (node_x[face[1]], node_y[face[1]], node_z[face[1]]), 
            (node_x[face[2]], node_y[face[2]], node_z[face[2]]), 
            (node_x[face[3]], node_y[face[3]], node_z[face[3]]), 
            point
            )
        # println(cross)
        # println(((node_x[face[1]], node_y[face[1]], node_z[face[1]]), 
        # (node_x[face[2]], node_y[face[2]], node_z[face[2]]), 
        # (node_x[face[3]], node_y[face[3]], node_z[face[3]])))
        if cross == -1
            return -1
        end
        if cross == 1
            c = 1 - c
        end
    end
    return c
end

function face_beyond_box_of_ray(nodeA::NTuple{3, Float64}, nodeB::NTuple{3, Float64}, nodeC::NTuple{3, Float64}, point::NTuple{3, Float64}) 
    Y = minimum((nodeA[2],nodeB[2],nodeC[2]))<=point[2]<=maximum((nodeA[2],nodeB[2],nodeC[2]))
    Z = minimum((nodeA[3],nodeB[3],nodeC[3]))<=point[3]<=maximum((nodeA[3],nodeB[3],nodeC[3]))
    return !(Y && Z)
end

function pcrossface(nodeA::NTuple{3, Float64}, nodeB::NTuple{3, Float64}, nodeC::NTuple{3, Float64}, point::NTuple{3, Float64})

    if face_beyond_box_of_ray(nodeA, nodeB, nodeC, point)
        return 0
    end

    node1 = collect(nodeA)
    node2 = collect(nodeB)
    node3 = collect(nodeC)
    O = collect(point)

    e1 = node2 - node1
    e2 = node3 - node1

    D = Float64[INF, 0., 0.]

    P = cross_product(Tuple(D), Tuple(e2))

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

    Q = cross_product(Tuple(T), Tuple(e1))
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
        return pcrossface(nodeA, nodeB, nodeC, (point[1] + BIAS[1], point[2] + BIAS[2], point[3] + BIAS[3]))
    end

    # 已知射线与三角形平面的交点在三角形内（不包括边上），且射线起点不在三角形平面内。
    return 1     
end