# This file is part of MXE.
# See index.html for further information.

# 2.8.11 is recommended as a minimum for Qt5
# http://doc.qt.io/qt-5/cmake-manual.html
cmake_minimum_required(VERSION 2.8.11)

# set languages in individual modules
project(mxe NONE)

# see cmake --help-policy <cmp> for details
cmake_policy(SET CMP0017 NEW)
cmake_policy(SET CMP0020 NEW)

# so we can find pkg-test.cmake files to include
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/../.. ${CMAKE_MODULE_PATH})

include(${PKG}-test)
