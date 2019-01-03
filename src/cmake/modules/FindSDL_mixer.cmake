# This file is part of MXE. See LICENSE.md for licensing information.

message("== Custom MXE File: " ${CMAKE_CURRENT_LIST_FILE})

if(NOT PKG_CONFIG_FOUND)
  find_package(PkgConfig REQUIRED)
endif()

pkg_check_modules(SDL_MIXER SDL_mixer)

#compatibility
set(SDL_MIXER_VERSION_STRING ${SDL_MIXER_VERSION})

# for backward compatibility
set(SDLMIXER_LIBRARY ${SDL_MIXER_LIBRARIES})
set(SDLMIXER_INCLUDE_DIR ${SDL_MIXER_INCLUDE_DIRS})
set(SDLMIXER_FOUND ${SDL_MIXER_FOUND})
