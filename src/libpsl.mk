# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libpsl
$(PKG)_WEBSITE  := https://github.com/rockdaboot/libpsl
$(PKG)_DESCR    := C library for the Public Suffix List
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.23.3
$(PKG)_CHECKSUM := 93941f85a1e7bd593fa94f299233cb5dfc91cd144fd9a78a6ceb75001c5b03be
# Filter out releases <= 0.21.1 which used different naming
$(PKG)_GH_CONF  := rockdaboot/libpsl/releases,,,libpsl
$(PKG)_DEPS     := cc meson-wrapper glib libidn2 libxml2 sqlite

define $(PKG)_BUILD
    LDFLAGS=-liconv '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Druntime=libidn2 \
        -Dbuiltin=true \
        -Ddocs=false \
        -Dtests=false \
        $(PKG_MESON_OPTS) \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
