# This file is part of MXE. See LICENSE.md for licensing information.

message("== Custom MXE File: " ${CMAKE_CURRENT_LIST_FILE})

if(NOT PKG_CONFIG_FOUND)
  find_package(PkgConfig REQUIRED)
endif()

pkg_check_modules(FRIBIDI fribidi)

# for backward compatibility
set(FRIBIDI_LIBRARY ${FRIBIDI_LIBRARIES})
set(FRIBIDI_INCLUDE_DIR ${FRIBIDI_INCLUDE_DIRS})
set(FRIBIDI_VERSION_STRING ${FRIBIDI_VERSION})
