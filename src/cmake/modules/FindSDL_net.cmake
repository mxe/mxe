# This file is part of MXE.
# See index.html for further information.

message("== Custom MXE File: " ${CMAKE_CURRENT_LIST_FILE})

if(NOT PKG_CONFIG_FOUND)
  find_package(PkgConfig REQUIRED)
endif()

pkg_check_modules(SDL_NET SDL_net)

#compatiblity
set(SDL_NET_VERSION_STRING ${SDL_NET_VERSION})

# for backward compatiblity
set(SDLNET_LIBRARY ${SDL_NET_LIBRARIES})
set(SDLNET_INCLUDE_DIR ${SDL_NET_INCLUDE_DIRS})
set(SDLNET_FOUND ${SDL_NET_FOUND})
