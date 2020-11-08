# PointInPoly

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://HetaoZ.github.io/PointInPoly.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://HetaoZ.github.io/PointInPoly.jl/dev)
[![Build Status](https://github.com/HetaoZ/PointInPoly.jl/workflows/CI/badge.svg)](https://github.com/HetaoZ/PointInPoly.jl/actions)
[![Coverage](https://codecov.io/gh/HetaoZ/PointInPoly.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/HetaoZ/PointInPoly.jl)



Check if a point lies in a 2D polygon (available) or a 3D polyhedron (planned, currently not available). Return 1 if inside, 0 if outside, -1 if exactly on the edge. 

`vertices_x`/`vertices_y`: Vector of `x`/`y` of the polygon vertices. Note that `x[end] != x[1]` (very important).
 
`point_x`/`point_y`: `x`/`y` of the point.

This algorithm was proposed by W. Randolph Franklin: https://wrf.ecse.rpi.edu//Research/Short_Notes/pnpoly.html. Extension to "3D point in polyhedron" is still in plan.

# Install
```
] add https://github.com/HetaoZ/PointInPoly.jl.git
```

# Usage
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
