# This file is part of MXE.
# See index.html for further information.

# partial module - included by src/cmake/CMakeLists.txt

set(TGT test-${PKG}-cmake)

enable_language(CXX)

find_package(Qt4 ${PKG_VERSION} EXACT REQUIRED)
include(${QT_USE_FILE})

include_directories("${PROJECT_BINARY_DIR}")

file(GLOB sources "${CMAKE_CURRENT_LIST_DIR}/qt-test.cpp")

QT4_WRAP_UI(UISrcs "${CMAKE_CURRENT_LIST_DIR}/qt-test.ui")
QT4_WRAP_CPP(MOCrcs "${CMAKE_CURRENT_LIST_DIR}/qt-test.hpp")
QT4_ADD_RESOURCES(RCSrcs "${CMAKE_CURRENT_LIST_DIR}/qt-test.qrc")

add_executable(${TGT} WIN32 ${sources} ${UISrcs} ${MOCrcs} ${RCSrcs})
target_link_libraries(${TGT} ${QT_LIBRARIES})

install(TARGETS ${TGT} DESTINATION bin)
