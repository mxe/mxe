# This file is part of MXE. See LICENSE.md for licensing information.

# partial module - included by src/cmake/CMakeLists.txt

set(TGT test-${PKG}-cmake)

enable_language(C)
add_executable(${TGT} ${CMAKE_CURRENT_LIST_DIR}/${PKG}-test.c)

find_package(PkgConfig REQUIRED)
pkg_check_modules(GLIB2 glib-2.0)

include_directories(${GLIB2_INCLUDE_DIRS})
target_link_libraries(${TGT} omemo-conversations
                             mxml
                             gcrypt
                             gpg-error
                             pthread
                             ${GLIB2_LIBRARIES})

install(TARGETS ${TGT} DESTINATION bin)

