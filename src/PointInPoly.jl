module PointInPoly
using Markdown

@doc """
```julia
ans = pinpoly(vertices_x::Vector, vertices_y::Vector, point_x::Real, point_y::Real)
```
Find if a point lies within a 2D polygon. Return 0 if it lies inside, else return 1. 

`vertices_x`/`vertices_y`: Vector of `x`/`y` of the polygon vertices. Note that `x[end] != x[1]` (very important).
 
`point_x`/`point_y`: `x`/`y` of the point.

This algorithm was proposed by W. Randolph Franklin: https://wrf.ecse.rpi.edu//Research/Short_Notes/pnpoly.html. Extension to "3D point in polyhedron" is still in plan.
""" ->  
function pinpoly(vertices_x::Vector, vertices_y::Vector, point_x::Real, point_y::Real)
    @assert length(vertices_x) == length(vertices_y)
    nvert = length(vertices_x)
    VertX = [vertices_x; vertices_x[1]]
    VertY = [vertices_y; vertices_y[1]]
    if ( (point_x < minimum(VertX)) || (point_x > maximum(VertX)) || (point_y < minimum(VertY)) || (point_y > maximum(VertY)) )
        c = 1
    else
        c = 1
        for i = 1:nvert
            j = i + 1
            if ( (VertY[i] > point_y) ⊻ (VertY[j] > point_y ) ) && ( point_x < (VertX[j] - VertX[i]) * (point_y - VertY[i]) / (VertY[j] - VertY[i]) + VertX[i] )
                # ⊻ : \xor
                c = 1 - c
            end
        end
    end
    # c = 0: inside, 1: outside
    return c
end
export pinpoly  

end
