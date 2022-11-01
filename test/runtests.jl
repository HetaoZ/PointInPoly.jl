using PointInPoly
using Test

@testset "PointInPoly.jl" begin

    # 2D polygon

    P = ((0., 0.), (1., 0.), (1., 1.), (0., 1.)) # coordinates of polygon vertices
    faces = ((P[1], P[2]), (P[3], P[2]), (P[3], P[4]), (P[1], P[4]))
    start = (0., 0.)
    stop = (1., 1.)

    # point
    points = (
            ((0.5,  0.2), 1),
            ((-0.4, 0.3), 0),
            ((0.,  0.25), -1),
            ((0.7, -1.1), 0),
            ((0.1,   0.), -1),
            ((1.0,  1.0), -1)
            )

    # check
    for point in points
        println(point[1], " => ", pinpoly(point[1], faces, start, stop)," (The correct answer is ", point[2],")")
    end

    # 3D polyhedron

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
        (( 0.1,  0.1,  0.01),  1),
        (( 0.1,  0.1,    0.),  -1),
        (( 0.1,  0.1,  -0.1),  0),
        ((  0.,   0.,   0.5),  -1),
        ((  0.,  0.1,   0.1),  -1),
        ((  0.,   0.,   1.1),   0),
        (( 1/4,  1/4,   1/2),   1)
        )

    for point in points
        println(point[1]," => ", pinpoly(point[1], faces, start, stop), " (The correct answer is ", point[2],")")
    end
end
