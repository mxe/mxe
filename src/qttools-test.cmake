# This file is part of MXE. See LICENSE.md for licensing information.

# partial module - included by src/cmake/CMakeLists.txt

set(TGT test-${PKG}-cmake)
set(QT_MAJOR 5 CACHE STRING "")

enable_language(CXX)
add_executable(${TGT} ${CMAKE_CURRENT_LIST_DIR}/${PKG}-test.cpp)

find_package(Qt${QT_MAJOR} ${PKG_VERSION} EXACT REQUIRED COMPONENTS UiTools)

# still requires extra Qt5::Gui since cmake gets the ordering wrong
target_link_libraries(${TGT} Qt::UiTools Qt::Gui)

install(TARGETS ${TGT} DESTINATION bin)
