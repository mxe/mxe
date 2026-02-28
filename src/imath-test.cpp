#include <iostream>
#include <Imath/ImathVec.h>
#include <Imath/ImathMatrix.h>

/*
    Minimal test for Imath library (versioned namespace Imath_3_2)
    Works with MXE Windows static build.

    To compile with MXE (example):
    $ usr/bin/x86_64-w64-mingw32.static-g++ src/imath-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include/ \
        -L usr/x86_64-w64-mingw32.static/lib/ \
        -lImath-3_2 \
        -o imath-test.exe
*/

int main()
{
    using namespace Imath_3_2;

    // --- Vec3<float> arithmetic ---
    Vec3<float> v1(1.0f, 2.0f, 3.0f);
    Vec3<float> v2(4.0f, 5.0f, 6.0f);
    Vec3<float> v3 = v1 + v2;

    std::cout << "v1 + v2 = ("
              << v3.x << ", " << v3.y << ", " << v3.z << ")\n";

    // --- Matrix44<float> identity ---
    Matrix44<float> mat;
    mat.makeIdentity(); // set to identity matrix

    std::cout << "Matrix44 identity test completed successfully!" << std::endl;

    return 0;
}