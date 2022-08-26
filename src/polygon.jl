"""
Check if a point lies inside a 2D polygon. Return 1 if inside, 0 if outside, -1 if exactly on the edge. 

`pinpoly(vertices_x::NTuple{N,Float64}, vertices_y::NTuple{N,Float64}, point::NTuple{2, Float64}) where N
`

`vertices_x/y`: Vectors of the node positions of the polygon.

`faces`: Vector of the node numbers of the segment faces on the boundary.
 
`point`: Position of the point.

This algorithm was proposed by W. Randolph Franklin: https://wrf.ecse.rpi.edu//Research/Short_Notes/pnpoly.html.
"""  
function pinpoly(vertices_x::NTuple{N,Float64}, vertices_y::NTuple{N,Float64}, faces::NTuple{M,NTuple{2,Int}}, point::NTuple{2, Float64}) where N where M

    all_vertices_id = [face[1] for face in faces]
    VertX = vertices_x[all_vertices_id]
    VertY = vertices_y[all_vertices_id]

    if ( (point[1] < minimum(VertX)) || (point[1] > maximum(VertX)) || (point[2] < minimum(VertY)) || (point[2] > maximum(VertY)) )
        return 0
    end
    
    c = 0
    for face in faces
        start_x = vertices_x[face[1]]
        start_y = vertices_x[face[1]]
        stop_x = vertices_x[face[2]]
        stop_y = vertices_x[face[2]]

        if pinline(start_x, start_y, stop_x, stop_y, point[1], point[2])
            return -1
        end

        if ( (start_y > point[2]) ⊻ (stop_y > point[2] ) ) && ( point[1] < (stop_x - start_x) * (point[2] - start_y) / (stop_y - start_y) + start_x )
            # ⊻ : \xor
            c = 1 - c
        end
    end
    return c
end

function pinline(X1::Real, Y1::Real, X2::Real, Y2::Real, x::Real, y::Real)
    if X1 != X2 
        ans = (x - X1) * (Y2 - Y1) == (y - Y1) * (X2 - X1) && min(X1, X2) <= x <= max(X1, X2)
    else
        ans = min(Y1, Y2) <= y <= max(Y1, Y2) 
    end
    return ans
end

