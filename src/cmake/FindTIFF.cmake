# This file is part of MXE.
# See index.html for further information.

if(NOT PKG_CONFIG_FOUND)
  find_package(PkgConfig REQUIRED)
endif()

pkg_check_modules(TIFF libtiff-4)

# for backward compatiblity
set(TIFF_LIBRARY ${TIFF_LIBRARIES})
set(TIFF_INCLUDE_DIR ${TIFF_INCLUDE_DIRS})
set(TIFF_VERSION_STRING ${TIFF_VERSION})
