# This file is part of MXE.
# See index.html for further information.

PKG            := mxe-conf
$(PKG)_VERSION := 1
$(PKG)_UPDATE  := echo 1

define $(PKG)_BUILD_COMMON
    # install target-specific autotools config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/share'
    echo "ac_cv_build=$(BUILD)" > '$(PREFIX)/$(TARGET)/share/config.site'

    # install config.guess for general use
    $(INSTALL) -d '$(PREFIX)/bin'
    $(INSTALL) -m755 '$(EXT_DIR)/config.guess' '$(PREFIX)/bin/'

    # create the CMake toolchain file
    # individual packages (e.g. hdf5) should add their
    # own files under CMAKE_TOOLCHAIN_DIR
    [ -d '$(CMAKE_TOOLCHAIN_DIR)' ] || mkdir -p '$(CMAKE_TOOLCHAIN_DIR)'
    (echo 'set(CMAKE_SYSTEM_NAME Windows)'; \
     echo 'set(MSYS 1)'; \
     echo 'set(BUILD_SHARED_LIBS $(if $(BUILD_SHARED),ON,OFF))'; \
     echo 'set(LIBTYPE $(if $(BUILD_SHARED),SHARED,STATIC))'; \
     echo 'set(CMAKE_BUILD_TYPE Release)'; \
     echo 'set(CMAKE_FIND_ROOT_PATH $(PREFIX)/$(TARGET))'; \
     echo 'set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)'; \
     echo 'set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)'; \
     echo 'set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)'; \
     echo 'set(CMAKE_C_COMPILER $(PREFIX)/bin/$(TARGET)-gcc)'; \
     echo 'set(CMAKE_CXX_COMPILER $(PREFIX)/bin/$(TARGET)-g++)'; \
     echo 'set(CMAKE_Fortran_COMPILER $(PREFIX)/bin/$(TARGET)-gfortran)'; \
     echo 'set(CMAKE_RC_COMPILER $(PREFIX)/bin/$(TARGET)-windres)'; \
     echo 'set(CMAKE_MODULE_PATH "$(PWD)/src/cmake" $${CMAKE_MODULE_PATH}) # For mxe FindPackage scripts'; \
     echo 'set(CMAKE_INSTALL_PREFIX $(PREFIX)/$(TARGET) CACHE PATH "Installation Prefix")'; \
     echo 'set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug|Release|RelWithDebInfo|MinSizeRel")'; \
     echo 'set(CMAKE_CROSS_COMPILING ON) # Workaround for http://www.cmake.org/Bug/view.php?id=14075'; \
     echo 'set(CMAKE_RC_COMPILE_OBJECT "<CMAKE_RC_COMPILER> -O coff <FLAGS> <DEFINES> -o <OBJECT> <SOURCE>") # Workaround for buggy windres rules'; \
     echo ''; \
     echo 'file(GLOB mxe_cmake_files'; \
     echo '    "$(CMAKE_TOOLCHAIN_DIR)/*.cmake"'; \
     echo ')'; \
     echo 'foreach(mxe_cmake_file $${mxe_cmake_files})'; \
     echo '    include($${mxe_cmake_file})'; \
     echo 'endforeach()'; \
     ) > '$(CMAKE_TOOLCHAIN_FILE)'
endef

define $(PKG)_BUILD
    $($(PKG)_BUILD_COMMON)

    # create pkg-config files for OpenGL/GLU
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: gl'; \
     echo 'Version: 0'; \
     echo 'Description: OpenGL'; \
     echo 'Libs: -lopengl32';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/gl.pc'

    (echo 'Name: glu'; \
     echo 'Version: 0'; \
     echo 'Description: OpenGL'; \
     echo 'Libs: -lglu32';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/glu.pc'
endef

$(PKG)_BUILD_$(BUILD) = $($(PKG)_BUILD_COMMON)
