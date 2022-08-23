"""
Check if a point lies inside a 2D polygon. Return 1 if inside, 0 if outside, -1 if exactly on the edge. 

`pinpoly(vertices_x::NTuple{N,Float64}, vertices_y::NTuple{N,Float64}, point::NTuple{2, Float64}) where N
`

`vertices_x`/`vertices_y`: Vector of `x`/`y` of the polygon vertices. Note that `x[end] != x[1]` (very important).
 
`point[1]`/`point[2]`: `x`/`y` of the point.

This algorithm was proposed by W. Randolph Franklin: https://wrf.ecse.rpi.edu//Research/Short_Notes/pnpoly.html.
"""  
function pinpoly(vertices_x::NTuple{N,Float64}, vertices_y::NTuple{N,Float64}, point::NTuple{2, Float64}) where N
    VertX = [collect(vertices_x); vertices_x[1]]
    VertY = [collect(vertices_y); vertices_y[1]]
    for i = 1:N
        if pinline(VertX[i], VertY[i], VertX[i+1], VertY[i+1], point[1], point[2])
            return -1
        end
    end
    if ( (point[1] < minimum(VertX)) || (point[1] > maximum(VertX)) || (point[2] < minimum(VertY)) || (point[2] > maximum(VertY)) )
        return 0
    end
    c = 0
    for i = 1:N
        j = i + 1
        if ( (VertY[i] > point[2]) ⊻ (VertY[j] > point[2] ) ) && ( point[1] < (VertX[j] - VertX[i]) * (point[2] - VertY[i]) / (VertY[j] - VertY[i]) + VertX[i] )
            # ⊻ : \xor
            c = 1 - c
        end
    end
    return c
end
 
function pinline(X1::Real, Y1::Real, X2::Real, Y2::Real, x::Real, y::Real)
    if X1 != X2 
        return (x - X1) * (Y2 - Y1) == (y - Y1) * (X2 - X1) && x <= max(X1, X2) && x >= min(X1, X2)
    else
        return y <= max(Y1, Y2) && y >= min(Y1, Y2)
    end
end

function pinpoly(xs::Array, point::Vector)
    if size(xs, 2) == 1
        if point[1] < maximum(xs) && point[1] > minimum(xs)
            return 1
        elseif point[1] in xs
            return -1
        else
            return 0
        end
    elseif size(xs, 2) == 2
        return pinpoly(xs[:,1], xs[:,2], point[1], point[2])
    else
        error("undef")
    end
end
