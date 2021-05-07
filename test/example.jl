include("../src/polyhedron.jl")

node_x=Tuple(Float64[0,1,0,0])
node_y=Tuple(Float64[0,0,1,0])
node_z=Tuple(Float64[0,0.001,0,1])
faces = ((1,2,3), (1,2,4), (2,3,4), (1,3,4))
points = ((0.01, 0.01, 0.01), (0.01,0.01,0.), (0.01, 0.01, -0.01))
for point in points
    println(point," -> ", pinpoly(node_x, node_y, node_z, faces, point))
end