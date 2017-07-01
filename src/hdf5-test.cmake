# This file is part of MXE. See LICENSE.md for licensing information.

# partial module - included by src/cmake/CMakeLists.txt

set(TGT test-${PKG}-cmake)

enable_language(CXX)
add_executable(${TGT} ${CMAKE_CURRENT_LIST_DIR}/${PKG}-test.cpp)

find_package(HDF5 ${PKG_VERSION} EXACT REQUIRED COMPONENTS C HL)
target_link_libraries(${TGT} ${HDF5_HL_LIBRARIES} ${HDF5_LIBRARIES})

install(TARGETS ${TGT} DESTINATION bin)
