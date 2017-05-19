/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 *
 * This code was originally found on:
 *   https://eigen.tuxfamily.org/dox/GettingStarted.html
 */

#include <Eigen/Dense>

using Eigen::MatrixXd;

int main()
{
    MatrixXd m(2,2);
    m(0,0) = 3;
    m(1,0) = 2.5;
    m(0,1) = -1;
    m(1,1) = m(1,0) + m(0,1);
    return 0;
}
