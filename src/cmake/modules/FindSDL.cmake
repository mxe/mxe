# This file is part of MXE.
# See index.html for further information.

if(NOT PKG_CONFIG_FOUND)
  find_package(PkgConfig REQUIRED)
endif()

pkg_check_modules(SDL sdl)

# for backward compatiblity
set(SDL_LIBRARY ${SDL_LIBRARIES})
set(SDL_INCLUDE_DIR ${SDL_INCLUDE_DIRS})
set(SDL_VERSION_STRING ${SDL_VERSION})
