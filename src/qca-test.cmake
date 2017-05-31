# This file is part of MXE. See LICENSE.md for licensing information.

# partial module - included by src/cmake/CMakeLists.txt

set(TGT test-${PKG}-cmake)

enable_language(CXX)
add_executable(${TGT} ${CMAKE_CURRENT_LIST_DIR}/${PKG}-test.cpp)

find_package(Qt5Core REQUIRED)
find_package(Qca-qt5 REQUIRED)

include_directories (${Qt5Core_INCLUDE_DIRS})
target_link_libraries(${TGT} Qt5::Core qca-qt5)

# Statically link QCA plugins when necessary
if(BUILD_STATIC_LIBS)
    target_link_libraries(${TGT} qca-ossl)
endif(BUILD_STATIC_LIBS)

install(TARGETS ${TGT} DESTINATION bin)
