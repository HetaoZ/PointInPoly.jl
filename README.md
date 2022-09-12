# PointInPoly

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://HetaoZ.github.io/PointInPoly.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://HetaoZ.github.io/PointInPoly.jl/dev)
[![Build Status](https://github.com/HetaoZ/PointInPoly.jl/workflows/CI/badge.svg)](https://github.com/HetaoZ/PointInPoly.jl/actions)
[![Coverage](https://codecov.io/gh/HetaoZ/PointInPoly.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/HetaoZ/PointInPoly.jl)

Determine if a point lies inside a 1D segment/2D polygon/3D polyhedron. Return 1 if inside, 0 if outside, -1 if exactly on any face. 

    pinpoly(point::NTuple{dim,Float64}, faces::NTuple{N,NTuple{dim,NTuple{dim,Float64}}}, start::NTuple{dim,Float64}, stop::NTuple{dim,Float64}) where N where dim
    
`faces`: Tuples of the node position of all `face`s on the boundary. A `face` is referred to a node/segment/triangle in 1/2/3D space, and its normal vector must be outward.

`point`: Position of the point.

`start`: The minimum coordinates among all nodes

`stop`: The maximum coordinates among all nodes

This algorithm was proposed by W. Randolph Franklin: https://wrf.ecse.rpi.edu//Research/Short_Notes/pnpoly.html.

# Installation
```
] add https://github.com/HetaoZ/PointInPoly.jl.git
```

# Usage
## 2D polygon
```
using PointInPoly

# coordinates of polygon vertices
P = ((0., 0.), (1., 0.), (1., 1.), (0., 1.))
faces = ((P[1], P[2]), (P[2], P[3]), (P[3], P[4]), (P[4], P[1])
start = (0., 0.)
stop = (1., 1.)

# point
point = (0.5, 0.2)

# check
pinpoly(point, faces, start, stop)
```
## 3D polyhedron
```
using PointInPoly

P = ((0., 0., 0.),
    (1., 0., 0.),
    (0., 1., 0.),
    (0., 0., 1.))
faces  = ((P[1],P[3],P[2]), 
        (P[1],P[2],P[4]), 
        (P[2],P[3],P[4]), 
        (P[3],P[1],P[4]))

points = (
    (0.01, 0.01, 0.01), 
    (0.01,0.01,0.), 
    (0.01, 0.01, -0.01), 
    (0., 0., 0.5), 
    (0., 0.1, 0.1), 
    (0., 0., 1.1)
    )

for point in points
    println(point," => ", pinpoly(node_x, node_y, node_z, faces, point))
end
```