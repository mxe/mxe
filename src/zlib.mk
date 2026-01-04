# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := zlib
$(PKG)_WEBSITE  := https://zlib.net/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.1
$(PKG)_CHECKSUM := 38ef96b8dfe510d42707d9c781877914792541133e1870841463bfa73f883e32
$(PKG)_GH_CONF  := madler/zlib/releases,v,,,,.tar.xz
$(PKG)_DEPS     := cc
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

$(PKG)_DEPS_$(BUILD) :=

define $(PKG)_BUILD
    cd '$(1)' && CHOST='$(TARGET)' ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --static
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef

define $(PKG)_BUILD_SHARED
    $(MAKE) -C '$(1)' -f win32/Makefile.gcc \
        SHARED_MODE=1 \
        STATICLIB= \
        BINARY_PATH='$(PREFIX)/$(TARGET)/bin' \
        INCLUDE_PATH='$(PREFIX)/$(TARGET)/include' \
        LIBRARY_PATH='$(PREFIX)/$(TARGET)/lib' \
        PREFIX='$(TARGET)-' \
        -j '$(JOBS)' install
endef
