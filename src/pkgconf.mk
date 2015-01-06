# This file is part of MXE.
# See index.html for further information.

PKG             := pkgconf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := da179fd
$(PKG)_CHECKSUM := 1e7b5ffe35ca4580a9b801307c3bc919fd77a4fd
$(PKG)_SUBDIR   := $(PKG)-$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://github.com/$(PKG)/$(PKG)/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

$(PKG)_DEPS_$(BUILD) := automake

$(PKG)_UPDATE    = $(call MXE_GET_GITHUB_SHA, pkgconf/pkgconf, master)

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package pkgconf.' >&2;
    echo $(pkgconf_VERSION)
endef

define $(PKG)_BUILD_COMMON
    cd '$(1)' && ./autogen.sh
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    # install target-specific autotools config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/share'
    echo "ac_cv_build=$(BUILD)" > '$(PREFIX)/$(TARGET)/share/config.site'

    # install config.guess for general use
    $(INSTALL) -d '$(PREFIX)/bin'
    $(INSTALL) -m755 '$(EXT_DIR)/config.guess' '$(PREFIX)/bin/'

    # create pkg-config script
    (echo '#!/bin/sh'; \
     echo 'PKG_CONFIG_PATH="$(PREFIX)/$(TARGET)/qt5/lib/pkgconfig":"$$PKG_CONFIG_PATH_$(subst .,_,$(subst -,_,$(TARGET)))" PKG_CONFIG_LIBDIR='\''$(PREFIX)/$(TARGET)/lib/pkgconfig'\'' exec '$(PREFIX)/$(TARGET)/bin/pkgconf' $(if $(BUILD_STATIC),--static) "$$@"') \
             > '$(PREFIX)/bin/$(TARGET)-pkg-config'
    chmod 0755 '$(PREFIX)/bin/$(TARGET)-pkg-config'

    # create the CMake toolchain file
    # individual packages (e.g. hdf5) should remove/append their own entries
    [ -d '$(dir $(CMAKE_TOOLCHAIN_FILE))' ] || mkdir -p '$(dir $(CMAKE_TOOLCHAIN_FILE))'
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
     echo 'set(PKG_CONFIG_EXECUTABLE $(PREFIX)/bin/$(TARGET)-pkg-config)'; \
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
