# This file is part of MXE.
# See index.html for further information.

# partial module - included by src/cmake/CMakeLists.txt

set(TGT test-${PKG}-cmake)

enable_language(C)
add_executable(${TGT} ${CMAKE_CURRENT_LIST_DIR}/${PKG}-test.c)

find_package(SDL ${PKG_VERSION} EXACT REQUIRED)
include_directories(${SDL_INCLUDE_DIRS})
target_link_libraries(${TGT} ${SDL_LIBRARIES})

install(TARGETS ${TGT} DESTINATION bin)
