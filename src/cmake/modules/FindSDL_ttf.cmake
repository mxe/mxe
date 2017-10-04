# This file is part of MXE. See LICENSE.md for licensing information.

message("== Custom MXE File: " ${CMAKE_CURRENT_LIST_FILE})

if(NOT PKG_CONFIG_FOUND)
  find_package(PkgConfig REQUIRED)
endif()

pkg_check_modules(SDL_TTF SDL_ttf)

#compatibility
set(SDL_TTF_VERSION_STRING ${SDL_TTF_VERSION})

# for backward compatibility
set(SDLTTF_LIBRARY ${SDL_TTF_LIBRARIES})
set(SDLTTF_INCLUDE_DIR ${SDL_TTF_INCLUDE_DIRS})
set(SDLTTF_FOUND ${SDL_TTF_FOUND})
