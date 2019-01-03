# This file is part of MXE. See LICENSE.md for licensing information.

message("== Custom MXE File: " ${CMAKE_CURRENT_LIST_FILE})

if(NOT PKG_CONFIG_FOUND)
  find_package(PkgConfig REQUIRED)
endif()

pkg_check_modules(SDL_IMAGE SDL_image)

# for backward compatibility
set(SDLIMAGE_LIBRARY ${SDL_IMAGE_LIBRARIES})
set(SDL_IMAGE_LIBRARY ${SDL_IMAGE_LIBRARIES})
set(SDLIMAGE_INCLUDE_DIR ${SDL_IMAGE_INCLUDE_DIRS})
set(SDLIMAGE_FOUND ${SDL_IMAGE_FOUND})
