# This file is part of MXE.
# See index.html for further information.

# partial module - included by src/cmake/CMakeLists.txt

set(TGT test-${PKG}-cmake)

enable_language(CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt4 ${PKG_VERSION} EXACT REQUIRED)
include(${QT_USE_FILE})

add_executable(${TGT} WIN32 ${CMAKE_CURRENT_LIST_DIR}/${PKG}-test.cpp)
target_link_libraries(${TGT} ${QT_LIBRARIES})

install(TARGETS ${TGT} DESTINATION bin)
