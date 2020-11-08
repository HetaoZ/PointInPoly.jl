module PointInPoly
export pinpoly 

"""
Check if a point lies inside a 2D polygon. Return 1 if inside, 0 if outside, -1 if exactly on the edge. 

`vertices_x`/`vertices_y`: Vector of `x`/`y` of the polygon vertices. Note that `x[end] != x[1]` (very important).
 
`point_x`/`point_y`: `x`/`y` of the point.

This algorithm was proposed by W. Randolph Franklin: https://wrf.ecse.rpi.edu//Research/Short_Notes/pnpoly.html. Extension to "3D point in polyhedron" is still in plan.
"""  
function pinpoly(vertices_x::Vector, vertices_y::Vector, point_x::Real, point_y::Real)
    nvert = length(vertices_x)
    VertX = [vertices_x; vertices_x[1]]
    VertY = [vertices_y; vertices_y[1]]
    for i = 1:nvert
        if pinline(VertX[i], VertY[i], VertX[i+1], VertY[i+1], point_x, point_y)
            return -1
        end
    end
    if ( (point_x < minimum(VertX)) || (point_x > maximum(VertX)) || (point_y < minimum(VertY)) || (point_y > maximum(VertY)) )
        return 0
    end
    c = 0
    for i = 1:nvert
        j = i + 1
        if ( (VertY[i] > point_y) ⊻ (VertY[j] > point_y ) ) && ( point_x < (VertX[j] - VertX[i]) * (point_y - VertY[i]) / (VertY[j] - VertY[i]) + VertX[i] )
            # ⊻ : \xor
            c = 1 - c
        end
    end
    # c = 0: inside, 1: outside
    return c
end
 
function pinline(X1::Real, Y1::Real, X2::Real, Y2::Real, x::Real, y::Real)
    if (x - X1) * (Y2 - Y1) == (y - Y1) * (X2 - X1) 
        return true
    else
        return false
    end
end

end
