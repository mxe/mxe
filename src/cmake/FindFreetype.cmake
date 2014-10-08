find_package(PkgConfig REQUIRED)

pkg_check_modules(FREETYPE freetype2)

set(FREETYPE_LIBRARY ${FREETYPE_LIBRARIES}) #For compatibility
