# This file is part of MXE.
# See index.html for further information.

# > Use the cmake_minimum_required command at the
# > top of your main CMakeLists.txt file:
# https://cmake.org/cmake/help/latest/policy/CMP0000.html
# cmake --help-policy CMP0000

# 3.0.2 is Debian Stable version
cmake_minimum_required(VERSION 3.0.2)

# use default C and CXX languages
project(mxe)

# so we can find pkg-test.cmake files to include
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/../.. ${CMAKE_MODULE_PATH})

include(${PKG}-test)
