# PointInPoly

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://HetaoZ.github.io/PointInPoly.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://HetaoZ.github.io/PointInPoly.jl/dev)
[![Build Status](https://github.com/HetaoZ/PointInPoly.jl/workflows/CI/badge.svg)](https://github.com/HetaoZ/PointInPoly.jl/actions)
[![Coverage](https://codecov.io/gh/HetaoZ/PointInPoly.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/HetaoZ/PointInPoly.jl)

Determine whether a point lies inside a 2D polygon or a 3D polyhedron. Note that there is a bit difference between 2D and 3D cases.

For a 2D polygon, return 1 if inside, 0 if outside, -1 if exactly on the edge. 

For a 3D polyhedron, return 1 if inside, 0 if outside OR exactly on the edge. The detection for 'exactly on the edge' is being developed.

This algorithm was proposed by W. Randolph Franklin: https://wrf.ecse.rpi.edu//Research/Short_Notes/pnpoly.html. 

# Installation
```
] add https://github.com/HetaoZ/PointInPoly.jl.git
```

# Usage
## 2D polygon
```
using PointInPoly

# coordinates of polygon vertices, in clockwise or anti-clockwise sequence.
polyX = [0, 1, 1, 0]
polyY = [0, 0, 1, 1]

# point
pointX = 0.5
pointY = 0.2

# check
pinpoly(polyX, polyY, pointX, pointY)
```
## 3D polyhedron
```
using PointInPoly

node_x = Tuple(Float64[0,1,0,0])
node_y = Tuple(Float64[0,0,1,0])
node_z = Tuple(Float64[0,0.001,0,1])

faces  = ((1,2,3), (1,2,4), (2,3,4), (1,3,4))

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