# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := openthreads
$(PKG)_WEBSITE  := http://www.openscenegraph.org/
$(PKG)_DESCR    := OpenThreads
$(PKG)_IGNORE    = $(openscenegraph_IGNORE)
$(PKG)_VERSION   = $(openscenegraph_VERSION)
$(PKG)_CHECKSUM  = $(openscenegraph_CHECKSUM)
$(PKG)_SUBDIR    = $(openscenegraph_SUBDIR)
$(PKG)_FILE      = $(openscenegraph_FILE)
$(PKG)_URL       = $(openscenegraph_URL)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    echo $(openscenegraph_VERSION)
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DDYNAMIC_OPENTHREADS=$(CMAKE_SHARED_BOOL) \
        -DOSG_DETERMINE_WIN_VERSION=OFF \
        -DCMAKE_VERBOSE_MAKEFILE=TRUE \
        -DOPENTHREADS_ATOMIC_USE_MUTEX=ON

    $(MAKE) -C '$(BUILD_DIR)/src/OpenThreads' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)/src/OpenThreads' -j 1 install VERBOSE=1
endef
