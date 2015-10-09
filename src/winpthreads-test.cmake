# This file is part of MXE.
# See index.html for further information.

# partial module - included by src/cmake/CMakeLists.txt

set(TGT test-${PKG}-cmake)

enable_language(C)
add_executable(${TGT} ${CMAKE_CURRENT_LIST_DIR}/pthreads-test.c)

find_package(Threads REQUIRED)
if(Threads::Threads) # cmake 3.1.0+
    target_link_libraries(${TGT} Threads::Threads)
else()
    target_link_libraries(${TGT} ${CMAKE_THREAD_LIBS_INIT})
endif()

install(TARGETS ${TGT} DESTINATION bin)
