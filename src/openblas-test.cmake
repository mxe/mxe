# This file is part of MXE. See LICENSE.md for licensing information.

# partial module - included by src/cmake/CMakeLists.txt

set(TGT test-${PKG}-cmake)

enable_language(C)
add_executable(${TGT} ${CMAKE_CURRENT_LIST_DIR}/${PKG}-test.c)

find_package(BLAS REQUIRED)
target_link_libraries(${TGT} ${BLAS_LIBRARIES})

install(TARGETS ${TGT} DESTINATION bin)
