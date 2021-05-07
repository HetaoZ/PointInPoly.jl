#include <iostream>

using namespace std;

#define EPSILON 0.000001

// 3D vector
class Vector3d
{
public:
    Vector3d()
    {
    }

    ~Vector3d()
    {
    }

    Vector3d(double dx, double dy, double dz)
    {
        x = dx;
        y = dy;
        z = dz;
    }

    // 矢量赋值
    void set(double dx, double dy, double dz)
    {
        x = dx;
        y = dy;
        z = dz;
    }

    // 矢量相加
    Vector3d operator + (const Vector3d& v) const
    {
        return Vector3d(x + v.x, y + v.y, z + v.z);
    }

    // 矢量相减
    Vector3d operator - (const Vector3d& v) const
    {
        return Vector3d(x - v.x, y - v.y, z - v.z);
    }

    //矢量数乘
    Vector3d Scalar(double c) const
    {
        return Vector3d(c*x, c*y, c*z);
    }

    // 矢量点积
    double Dot(const Vector3d& v) const
    {
        return x * v.x + y * v.y + z * v.z;
    }

    // 矢量叉积
    Vector3d Cross(const Vector3d& v) const
    {
        return Vector3d(y * v.z - z * v.y, z * v.x - x * v.z, x * v.y - y * v.x);
    }

    double _x()
    {
        return x;
    }

    double _y()
    {
        return y;
    }

    double _z()
    {
        return z;
    }

private:
    double x, y, z;
};

//ray-triangle intersection algorithm
//参数说明：V1,V2,V3,三角形三点；O,射线原点；D,射线方向。
bool ray_triangle_intersection(Vector3d V1, Vector3d V2, Vector3d V3, Vector3d O, Vector3d D, Vector3d *I)
{
    //Find vectors for two edges sharing V1
    Vector3d e1 = V2 - V1;
    Vector3d e2 = V3 - V1;

    //Begin calculating determinant - also used to calculate u parameter
    Vector3d P = D.Cross(e2);
    //if determinant is near zero, ray lies in plane of triangle
    double det = e1.Dot(P);
    //NOT CULLING
    if (det > -EPSILON && det < EPSILON)
    {
        return false;
    }
    double inv_det = 1.f / det;

    //calculate distance from V1 to ray origin
    Vector3d T = O - V1;

    //Calculate u parameter and test bound
    double u = T.Dot(P) * inv_det;
    //The intersection lies outside of the triangle
    if (u < 0.f || u > 1.f)
    {
        return false;
    }

    //Prepare to test v parameter
    Vector3d Q = T.Cross(e1);
    //Calculate V parameter and test bound
    double v = D.Dot(Q) * inv_det;

    //The intersection lies outside of the triangle
    if (v < 0.f || u + v  > 1.f)
    {
        return false;
    }

    double t = e2.Dot(Q) * inv_det;

    //ray intersection
    if (t > EPSILON)
    {
        *I = O + D.Scalar(t);
        return true;
    }

    return false;
}

int main()
{
    Vector3d V1(0, 0, 0);
    Vector3d V2(50, 0, 0);
    Vector3d V3(0, 50, 0);
    Vector3d O(5, 10, -10);
    Vector3d P(10, 10, 10);
    Vector3d D = P - O;
    Vector3d I;

    if (ray_triangle_intersection(V1, V2, V3, O, D, &I)) {
        cout << I._x() << '\t' << I._y() << '\t' << I._z() << endl;
    }
}