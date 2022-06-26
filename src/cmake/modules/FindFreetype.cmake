# This file is part of MXE. See LICENSE.md for licensing information.

message("== Custom MXE File: " ${CMAKE_CURRENT_LIST_FILE})

if(NOT PKG_CONFIG_FOUND)
  find_package(PkgConfig REQUIRED)
endif()

if(NOT TARGET Freetype::Freetype)
  pkg_check_modules(FREETYPE freetype2)
  if(FREETYPE_FOUND)
    #For compatibility
    set(Freetype_FOUND ${FREETYPE_FOUND})
    set(Freetype_VERSION ${FREETYPE_VERSION})
    find_library(FREETYPE_LIBRARY NAMES freetype PATHS ${FREETYPE_LIBRARY_DIRS})
    find_path(FREETYPE_INCLUDE_DIR freetype.h PATHS ${FREETYPE_INCLUDE_DIRS})
    add_library(Freetype::Freetype UNKNOWN IMPORTED)
    set_target_properties(Freetype::Freetype PROPERTIES
      IMPORTED_LOCATION "${FREETYPE_LIBRARY}"
      INTERFACE_LINK_LIBRARIES "${FREETYPE_LIBRARIES}"
      INTERFACE_INCLUDE_DIRECTORIES "${FREETYPE_INCLUDE_DIRS}")
  endif()
endif()
