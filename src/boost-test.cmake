# This file is part of MXE.
# See index.html for further information.

# partial module - included by src/cmake/CMakeLists.txt

set(TGT test-${PKG}-cmake)

enable_language(CXX)
add_executable(${TGT} ${CMAKE_CURRENT_LIST_DIR}/${PKG}-test.cpp)

find_package(Boost ${PKG_VERSION} EXACT COMPONENTS chrono serialization system thread REQUIRED)
target_link_libraries(${TGT} ${Boost_LIBRARIES})

install(TARGETS ${TGT} DESTINATION bin)
