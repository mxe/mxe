# This file is part of MXE. See LICENSE.md for licensing information.

message("== Custom MXE File: " ${CMAKE_CURRENT_LIST_FILE})

if(NOT PKG_CONFIG_FOUND)
  find_package(PkgConfig REQUIRED)
endif()

pkg_check_modules(SDL_SOUND SDL_sound)

#compatibility
set(SDL_SOUND_VERSION_STRING ${SDL_SOUND_VERSION})
set(SDL_SOUND_LIBRARIES ${SDL_SOUND_EXTRAS};${SDL_SOUND_LIBRARIES})

# for backward compatibility
set(SDL_SOUND_LIBRARY ${SDL_SOUND_LIBRARIES})
