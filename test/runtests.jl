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
    println("Testing Points in Polygon")
    s1 = 0
    for point in points
        q = pinpoly(point[1], faces, start, stop)
        println(point[1], " => ", q," (", point[2]==q,")")
        if point[2] != q
            s1 += 1
        end
    end
    println("summary:")
    println("        ",length(points)-s1," points passed, ", s1," points failed")



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

    println()
    println("Testing Points in Polyhedon")
    s2 = 0
    for point in points
        q = pinpoly(point[1], faces, start, stop)
        println(point[1]," => ", q, " (", point[2]==q,")")
        if point[2] != q
            s2 += 1
        end
    end

    println("summary:")
    println("        ",length(points)-s2," points passed, ", s2," points failed")

    if s1+s2 > 0
        error("Some points failed!")
    end
end
