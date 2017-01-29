# This file is part of MXE. See LICENSE.md for licensing information.

cmake_minimum_required(VERSION 3.5.2)

project(mxe)

# see cmake --help-policy <cmp> for details
cmake_policy(SET CMP0017 NEW)
cmake_policy(SET CMP0020 NEW)
cmake_policy(SET CMP0028 NEW)

set(tgt test-${PKG}-cmake)

include_directories("${PROJECT_BINARY_DIR}")

if(${PKG} STREQUAL "qt")
    set(USING_QT4 TRUE)
elseif(${PKG} STREQUAL "qtbase")
    set(USING_QT5 TRUE)
else()
    message(FATAL_ERROR unknown package: ${PKG})
endif()

# https://cmake.org/cmake/help/latest/manual/cmake-qt.7.html#manual:cmake-qt(7)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

if(USING_QT4)
    find_package(Qt4 ${PKG_VERSION} EXACT REQUIRED)
    set(link_modules Qt4::QtSvg)
    set(link_plugins ${QT_QSVG_LIBRARY})
elseif(USING_QT5)
    # find_package needs to look for "Gui" to find it's plugins
    find_package(Qt5 ${PKG_VERSION} EXACT REQUIRED COMPONENTS Widgets Gui)

    # prefer "imported targets" style references, transitive
    # dependencies will be calculated and don't need to be
    # specified (e.g. Qt5::Gui Qt5::Core)
    # http://doc.qt.io/qt-5/cmake-manual.html#imported-targets
    set(link_modules Qt5::Widgets)
    set(link_plugins Qt5::QWindowsIntegrationPlugin Qt5::QICOPlugin)
endif()

add_executable(${tgt} WIN32 "${CMAKE_CURRENT_LIST_DIR}/../qt-test.cpp")
target_link_libraries(${tgt} ${link_modules})
set_property(TARGET ${tgt} PROPERTY RUNTIME_OUTPUT_NAME ${tgt}$<$<CONFIG:Debug>:d>)

# https://doc.qt.io/qt-5/plugins-howto.html#static-plugins
if(BUILD_STATIC)
    add_definitions(-DQT_STATICPLUGIN)
    target_link_libraries(${tgt} ${link_plugins})
endif()

install(TARGETS ${tgt} DESTINATION bin)
