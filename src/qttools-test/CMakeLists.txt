# This file is part of MXE. See LICENSE.md for licensing information.

# Source: https://github.com/mxe/mxe/issues/1185

cmake_minimum_required(VERSION 3.0)
find_package(Qt5 REQUIRED COMPONENTS Core Widgets Gui UiTools)

include_directories(${Qt5UiTools_INCLUDE_DIRS})
add_executable(mxe-cmake-qtuitools mxe-cmake-qtuitools.cpp)
# NB: Qt5Widgets, Qt5Gui, Qt5Core must be given separately; otherwise they are
# appended automatically at the end, making it impossible to satisfy all the
# other implicit dependencies (opengl, harfbuzz, etc.)
target_link_libraries(
    mxe-cmake-qtuitools
    ${Qt5UiTools_LIBRARIES}
    ${Qt5Widgets_LIBRARIES}
    ${Qt5Gui_LIBRARIES}
    ${Qt5Core_LIBRARIES}
    opengl32
    harfbuzz
    jpeg
    png
    glib-2.0
    winmm
    ws2_32
    intl
    iconv
    pcre16
    z
)
