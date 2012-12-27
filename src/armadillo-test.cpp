/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <armadillo>

using namespace arma;

int main()
{
    mat A = randu<mat>(50,50);
    mat B = trans(A)*A;  // generate a symmetric matrix

    vec eigval;
    mat eigvec;

    // use standard algorithm by default
    eig_sym(eigval, eigvec, B);

    // use divide & conquer algorithm
    eig_sym(eigval, eigvec, B, "dc");
    return 0;
}
