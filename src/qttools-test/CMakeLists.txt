# This file is part of MXE. See LICENSE.md for licensing information.

# Source: https://github.com/mxe/mxe/issues/1185
# simplified in https://github.com/mxe/mxe/pull/1645

cmake_minimum_required(VERSION 3.0)
find_package(Qt5 REQUIRED COMPONENTS UiTools)

add_executable(test-qttools mxe-cmake-qtuitools.cpp)
target_link_libraries(test-qttools Qt5::UiTools)
install(TARGETS test-qttools DESTINATION bin)
