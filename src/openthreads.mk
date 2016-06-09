# This file is part of MXE.
# See index.html for further information.

PKG             := openthreads
$(PKG)_IGNORE    = $(openscenegraph_IGNORE)
$(PKG)_VERSION   = $(openscenegraph_VERSION)
$(PKG)_CHECKSUM  = $(openscenegraph_CHECKSUM)
$(PKG)_SUBDIR    = $(openscenegraph_SUBDIR)
$(PKG)_FILE      = $(openscenegraph_FILE)
$(PKG)_URL       = $(openscenegraph_URL)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo $openscenegraph_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && '$(TARGET)-cmake' \
        -DDYNAMIC_OPENTHREADS=$(CMAKE_SHARED_BOOL) \
        -DCMAKE_VERBOSE_MAKEFILE=TRUE \
        -DOSG_USE_QT=FALSE \
        -DPOPPLER_HAS_CAIRO_EXITCODE=0 \
        -D_OPENTHREADS_ATOMIC_USE_GCC_BUILTINS_EXITCODE=1 \
        -D_OPENTHREADS_ATOMIC_USE_WIN32_INTERLOCKED=1 \
        '$(1)'

    $(MAKE) -C '$(1).build/src/OpenThreads' -j '$(JOBS)' install VERBOSE=1
endef
