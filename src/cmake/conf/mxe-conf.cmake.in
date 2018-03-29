# This file is part of MXE. See LICENSE.md for licensing information.

# https://cmake.org/cmake/help/latest

# Can't set `cmake_minimum_required` or `cmake_policy` in toolchain
# since toolchain is read before CMakeLists.txt
# See `target-cmake.in` for CMAKE_POLICY_DEFAULT_CMPNNNN

# Check if we are using mxe supplied version
#   - toolchain is included multiple times so set a guard in
#     environment to suppress duplicate messages
if(NOT ${CMAKE_COMMAND} STREQUAL @PREFIX@/@BUILD@/bin/cmake AND NOT DEFINED ENV{_MXE_CMAKE_TOOLCHAIN_INCLUDED})
    message(WARNING "
** Warning: direct use of toolchain file is deprecated
** Please use prefixed wrapper script instead:
     @TARGET@-cmake [options] <path-to-source>
       - uses mxe supplied cmake version @CMAKE_VERSION@
       - loads toolchain
       - loads common run results
       - sets various policy defaults
    ")
    set(ENV{_MXE_CMAKE_TOOLCHAIN_INCLUDED} TRUE)
endif()

# Use CACHE variables to allow user setting with `-D`
# Use CACHE FORCE in rare cases of misconfigured CMakeLists.txt
#   - e.g include(FindPkgConfig)
#     https://github.com/mxe/mxe/issues/1023
#   - projects may still set these in which case FORCE doesn't have
#     any advantage, just causes inconvenience
#     https://github.com/mxe/mxe/pull/1621#discussion_r106937505
# Use normal variables expected to be set by toolchain/system
#   - projects should test for these values and not try to override

## General configuration
set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR @PROCESSOR@ CACHE STRING "System Processor")
set(MSYS 1)
set(CMAKE_EXPORT_NO_PACKAGE_REGISTRY ON)
# Workaround for https://www.cmake.org/Bug/view.php?id=14075
set(CMAKE_CROSS_COMPILING ON)


## Library config
set(BUILD_SHARED_LIBS @CMAKE_SHARED_BOOL@ CACHE BOOL "BUILD_SHARED_LIBS")
set(BUILD_STATIC_LIBS @CMAKE_STATIC_BOOL@ CACHE BOOL "BUILD_STATIC_LIBS")
set(BUILD_SHARED @CMAKE_SHARED_BOOL@ CACHE BOOL "BUILD_SHARED")
set(BUILD_STATIC @CMAKE_STATIC_BOOL@ CACHE BOOL "BUILD_STATIC")
set(LIBTYPE @LIBTYPE@)


## Paths etc.
# These MODEs shouldn't be changed by users, we only want headers/libs
# from cross-build and "never" want binaries. We do, however, want
# `*-config` scripts but there's no way to instruct cmake to do that.
#
# The best solution may be to whitelist utilities
#   https://github.com/mxe/mxe/issues/1667
# and symlink them to an additional root path, changing PROGRAM to ONLY

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Allow user to specify list of locations to search
set(CMAKE_FIND_ROOT_PATH @PREFIX@/@TARGET@ CACHE PATH "List of root paths to search on the filesystem")
set(CMAKE_PREFIX_PATH @PREFIX@/@TARGET@ CACHE PATH "List of directories specifying installation prefixes to be searched")
set(CMAKE_INSTALL_PREFIX @PREFIX@/@TARGET@ CACHE PATH "Installation Prefix")
# For custom mxe FindPackage scripts
set(CMAKE_MODULE_PATH "@PREFIX@/share/cmake/modules" ${CMAKE_MODULE_PATH})

# projects (mis)use `-isystem` to silence warnings from 3rd-party
# source (among other things). gcc6 introduces changes to search
# order which breaks this usage.
#   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=70129
#   https://gitlab.kitware.com/cmake/cmake/issues/16291
#   https://gitlab.kitware.com/cmake/cmake/issues/16919
set(CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES @PREFIX@/@TARGET@/include)
set(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES @PREFIX@/@TARGET@/include)


## Programs
set(CMAKE_C_COMPILER @PREFIX@/bin/@TARGET@-gcc)
set(CMAKE_CXX_COMPILER @PREFIX@/bin/@TARGET@-g++)
set(CMAKE_Fortran_COMPILER @PREFIX@/bin/@TARGET@-gfortran)
set(CMAKE_RC_COMPILER @PREFIX@/bin/@TARGET@-windres)
# CMAKE_RC_COMPILE_OBJECT is defined in:
#     <cmake root>/share/cmake-X.Y/Modules/Platform/Windows-windres.cmake
set(CPACK_NSIS_EXECUTABLE @TARGET@-makensis)

## Individual package configuration
file(GLOB mxe_cmake_files
    "@CMAKE_TOOLCHAIN_DIR@/*.cmake"
)
foreach(mxe_cmake_file ${mxe_cmake_files})
    include(${mxe_cmake_file})
endforeach()
