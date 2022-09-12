include("../src/PointInPoly.jl")
using .PointInPoly

P = (
    (0., 0., 0.),
    (1., 0., 0.),
    (0., 1., 0.),
    (0., 0., 1.)
    )
faces = (
    (P[1], P[3], P[2]), 
    (P[1], P[2], P[4]), 
    (P[2], P[3], P[4]), 
    (P[3], P[1], P[4])
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