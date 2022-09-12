# PointInPoly

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://HetaoZ.github.io/PointInPoly.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://HetaoZ.github.io/PointInPoly.jl/dev)
[![Build Status](https://github.com/HetaoZ/PointInPoly.jl/workflows/CI/badge.svg)](https://github.com/HetaoZ/PointInPoly.jl/actions)
[![Coverage](https://codecov.io/gh/HetaoZ/PointInPoly.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/HetaoZ/PointInPoly.jl)

Determine if a point lies inside a 1D segment/2D polygon/3D polyhedron. Return 1 if inside, 0 if outside, -1 if exactly on any face. 

    pinpoly(point::NTuple{dim,Float64}, faces::NTuple{N,NTuple{dim,NTuple{dim,Float64}}}, start::NTuple{dim,Float64}, stop::NTuple{dim,Float64}) where N where dim

`faces`: Tuples of the node position of all `face`s on the boundary. A `face` is referred to a node/segment/triangle in 1/2/3D space. The arrangement order of nodes, clockwise or anti-clockwise, doesn't matter.

`point`: Position of the point.

`start`: The minimum coordinates among all nodes

`stop`: The maximum coordinates among all nodes

References

[1] https://wrf.ecse.rpi.edu//Research/Short_Notes/pnpoly.html.

[2] https://blog.csdn.net/u012138730/article/details/80235813

# Installation
```
] add https://github.com/HetaoZ/PointInPoly.jl.git
```

# Usage
## 2D polygon
```
using PointInPoly

P = ((0., 0.), (1., 0.), (1., 1.), (0., 1.)) # coordinates of polygon vertices
faces = ((P[1], P[2]), (P[3], P[2]), (P[3], P[4]), (P[1], P[4]))
start = (0., 0.)
stop = (1., 1.)

# point
points = ((0.5, 0.2),
        (-0.4, 0.3),
        (0., 0.25),
        (0.7, -1.1),
        (0.1, 0.),
        (1.0, 1.0))

# check
for point in points
    println(point, " => ", pinpoly(point, faces, start, stop))
end
```
## 3D polyhedron
```
using PointInPoly

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