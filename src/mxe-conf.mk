# This file is part of MXE.
# See index.html for further information.

PKG            := mxe-conf
$(PKG)_VERSION := 1
$(PKG)_UPDATE  := echo 1
$(PKG)_TARGETS := $(BUILD) $(MXE_TARGETS)

define $(PKG)_BUILD
    # create basic non-empty directory hierarchy
    for d in bin include lib share; do \
        mkdir -p "$(PREFIX)/$(TARGET)/$$d" && \
        touch    "$(PREFIX)/$(TARGET)/$$d/.gitkeep" ; \
    done

    # install target-specific autotools config file
    # setting ac_cv_build bypasses the config.guess check in every package
    echo "ac_cv_build=$(BUILD)" > '$(PREFIX)/$(TARGET)/share/config.site'

    # create the CMake toolchain file using template
    # individual packages (e.g. hdf5) should add their
    # own files under CMAKE_TOOLCHAIN_DIR
    mkdir -p '$(CMAKE_TOOLCHAIN_DIR)'
    touch '$(CMAKE_TOOLCHAIN_DIR)/.gitkeep'
    echo 'configure_file($${CONF_IN} $${CONF_OUT} @ONLY)' \
        > '$(BUILD_DIR)/configure_file.cmake'
    cmake \
        -DCMAKE_VERSION=$(cmake_VERSION) \
        -DCMAKE_SHARED_BOOL=$(CMAKE_SHARED_BOOL) \
        -DCMAKE_STATIC_BOOL=$(CMAKE_STATIC_BOOL) \
        -DLIBTYPE=$(if $(BUILD_SHARED),SHARED,STATIC) \
        -DPREFIX=$(PREFIX) \
        -DTARGET=$(TARGET) \
        -DBUILD=$(BUILD) \
        -DCONF_IN='$(PWD)/src/mxe-conf.cmake.in' \
        -DCONF_OUT='$(CMAKE_TOOLCHAIN_FILE)' \
        -P '$(BUILD_DIR)/configure_file.cmake'

    #create prefixed cmake wrapper script
    cmake \
        -DTOOLCHAIN_FILE=$(CMAKE_TOOLCHAIN_FILE) \
        -DRUNRESULT_FILE=$(CMAKE_RUNRESULT_FILE) \
        -DPREFIX=$(PREFIX) \
        -DTARGET=$(TARGET) \
        -DBUILD=$(BUILD) \
        -DCONF_IN='$(PWD)/src/mxe-conf.cmake-script.in' \
        -DCONF_OUT='$(PREFIX)/bin/$(TARGET)-cmake' \
        -P '$(BUILD_DIR)/configure_file.cmake'
    chmod 0755 '$(PREFIX)/bin/$(TARGET)-cmake'

    # create pkg-config files for OpenGL/GLU
    mkdir -p '$(PREFIX)/$(TARGET)/lib/pkgconfig'
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

define $(PKG)_BUILD_$(BUILD)
    # install config.guess for general use
    mkdir -p '$(PREFIX)/bin'
    $(INSTALL) -m755 '$(EXT_DIR)/config.guess' '$(PREFIX)/bin/'

    # install cmake modules
    mkdir -p '$(PREFIX)/share/cmake/modules'
    $(INSTALL) -m644 '$(PWD)/src/cmake/modules/'* '$(PREFIX)/share/cmake/modules'

    # fail early if autotools can't autoreconf
    # 1. detect mismatches in installation locations
    # 2. ???
    (echo 'AC_INIT([mxe.cc], [1])'; \
     $(foreach PROG, autoconf automake libtool, \
         echo 'AC_PATH_PROG([$(call uc,$(PROG))], [$(PROG)])';) \
     echo 'PKG_PROG_PKG_CONFIG(0.16)'; \
     echo 'AC_OUTPUT') \
     > '$(1)/configure.ac'
    cd '$(1)' && autoreconf -fiv
    cd '$(1)' && ./configure

    #create readonly directory to force wine to fail
    mkdir -p "$$WINEPREFIX"
    [ -f "$$WINEPREFIX/.gitkeep" ] \
        || chmod 0755 "$$WINEPREFIX" \
        && touch "$$WINEPREFIX/.gitkeep"
    chmod 0555 "$$WINEPREFIX"

    #create script "wine" in a directory which is in PATH
    mkdir -p '$(PREFIX)/$(BUILD)/bin/'
    (echo '#!/usr/bin/env bash'; \
     echo 'exit 1'; \
    ) \
             > '$(PREFIX)/$(BUILD)/bin/wine'
    chmod 0755 '$(PREFIX)/$(BUILD)/bin/wine'
endef
