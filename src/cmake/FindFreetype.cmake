# This file is part of MXE.
# See index.html for further information.

if(NOT PKG_CONFIG_FOUND)
  find_package(PkgConfig REQUIRED)
endif()

pkg_check_modules(FREETYPE freetype2)

set(FREETYPE_LIBRARY ${FREETYPE_LIBRARIES}) #For compatibility
