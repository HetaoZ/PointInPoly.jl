# PointInPoly

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://HetaoZ.github.io/PointInPoly.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://HetaoZ.github.io/PointInPoly.jl/dev)
[![Build Status](https://github.com/HetaoZ/PointInPoly.jl/workflows/CI/badge.svg)](https://github.com/HetaoZ/PointInPoly.jl/actions)
[![Coverage](https://codecov.io/gh/HetaoZ/PointInPoly.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/HetaoZ/PointInPoly.jl)

Check if a point lies in a 2D polygon (available) or a 3D polyhedron (planned, currently not available).

# Install
```
] add https://github.com/HetaoZ/PointInPoly.jl.git
```

# Usage
```
using PointInPoly

# rectangle
polyX = [0 1 1 0]
polyY = [0 0 1 1]
pointX = 0.5
pointY = 0.2

# returns 0 if the point is inside, otherwise 1.
pinpoly(polyX, polyY, pointX, pointY)
```
