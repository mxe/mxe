# This file is part of MXE. See LICENSE.md for licensing information.

# partial module - included by src/cmake/CMakeLists.txt

set(TGT test-${PKG}-cmake)

enable_language(CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt5 ${PKG_VERSION} EXACT REQUIRED COMPONENTS Widgets)

add_executable(${TGT} ${CMAKE_CURRENT_LIST_DIR}/qt-test.cpp)

target_link_libraries(${TGT} Qt5::Widgets)

install(TARGETS ${TGT} DESTINATION bin)
