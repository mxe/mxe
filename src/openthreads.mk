# This file is part of MXE.
# See index.html for further information.

PKG             := openthreads
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4.0
$(PKG)_CHECKSUM := 5c727d84755da276adf8c4a4a3a8ba9c9570fc4b4969f06f1d2e9f89b1e3040e
$(PKG)_SUBDIR   := OpenSceneGraph-$($(PKG)_VERSION)
$(PKG)_FILE     := OpenSceneGraph-$($(PKG)_VERSION).zip
$(PKG)_URL      := http://trac.openscenegraph.org/downloads/developer_releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://trac.openscenegraph.org/downloads/developer_releases/?C=M;O=D' | \
    $(SED) -n 's,.*OpenSceneGraph-\([0-9]*\.[0-9]*[02468]\.[^<]*\)\.zip.*,\1,p' | \
    grep -v rc | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && '$(TARGET)-cmake' \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DCMAKE_VERBOSE_MAKEFILE=TRUE \
        -DPKG_CONFIG_EXECUTABLE='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        -D_OPENTHREADS_ATOMIC_USE_GCC_BUILTINS_EXITCODE=1 \
        -D_OPENTHREADS_ATOMIC_USE_WIN32_INTERLOCKED=1 \
        '$(1)'

    $(MAKE) -C '$(1).build' -j '$(JOBS)' install VERBOSE=1
endef
