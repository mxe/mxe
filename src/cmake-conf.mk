# This file is part of MXE. See LICENSE.md for licensing information.

PKG            := cmake-conf
$(PKG)_VERSION := 1
$(PKG)_UPDATE  := echo 1
$(PKG)_TARGETS := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS    := $(BUILD)~$(PKG)
$(PKG)_FILE_DEPS := $(wildcard $(PWD)/src/cmake/conf/*)
$(PKG)_DEPS_$(BUILD) := cmake

define $(PKG)_BUILD
    # create the CMake toolchain file using template
    # individual packages (e.g. hdf5) should add their
    # own files under CMAKE_TOOLCHAIN_DIR

    mkdir -p '$(CMAKE_TOOLCHAIN_DIR)'
    touch '$(CMAKE_TOOLCHAIN_DIR)/.gitkeep'
    cmake-configure-file \
        -DCMAKE_VERSION=$(cmake_VERSION) \
        -DCMAKE_SHARED_BOOL=$(CMAKE_SHARED_BOOL) \
        -DCMAKE_STATIC_BOOL=$(CMAKE_STATIC_BOOL) \
        -DLIBTYPE=$(if $(BUILD_SHARED),SHARED,STATIC) \
        -DPREFIX=$(PREFIX) \
        -DTARGET=$(TARGET) \
        -DBUILD=$(BUILD) \
        -DCMAKE_TOOLCHAIN_DIR='$(CMAKE_TOOLCHAIN_DIR)' \
        -DINPUT='$(PWD)/src/cmake/conf/mxe-conf.cmake.in' \
        -DOUTPUT='$(CMAKE_TOOLCHAIN_FILE)'

    #create prefixed cmake wrapper script
    cmake-configure-file \
        -DCMAKE_VERSION=$(cmake_VERSION) \
        -DPREFIX=$(PREFIX) \
        -DTARGET=$(TARGET) \
        -DBUILD=$(BUILD) \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_RUNRESULT_FILE='$(CMAKE_RUNRESULT_FILE)' \
        -DINPUT='$(PWD)/src/cmake/conf/target-cmake.in' \
        -DOUTPUT='$(PREFIX)/bin/$(TARGET)-cmake'
    chmod 0755 '$(PREFIX)/bin/$(TARGET)-cmake'

    ln -sf '$(PREFIX)/$(BUILD)/bin/cpack' '$(PREFIX)/bin/$(TARGET)-cpack'
endef

define $(PKG)_BUILD_$(BUILD)
    # install cmake modules
    mkdir -p '$(PREFIX)/share/cmake/modules'
    $(INSTALL) -m644 '$(PWD)/src/cmake/modules/'* '$(PREFIX)/share/cmake/modules'

    # install cmake-configure-file for general use
    # cmake-configure-file -DINPUT -DOUTPUT -DFOO -DBAR -D...
    mkdir -p '$(PREFIX)/bin'
    echo 'configure_file($${INPUT} $${OUTPUT} @ONLY)' \
        > '$(PREFIX)/share/cmake/modules/configure_file.cmake'
    (echo '#!/usr/bin/env bash'; \
     echo 'exec "$(PREFIX)/$(BUILD)/bin/cmake" "$$@" \
                    -P "$(PREFIX)/share/cmake/modules/configure_file.cmake"'; \
    ) \
             > '$(PREFIX)/bin/cmake-configure-file'
    chmod 0755 '$(PREFIX)/bin/cmake-configure-file'
endef
