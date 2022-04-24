# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libpsl
$(PKG)_WEBSITE  := https://github.com/rockdaboot/libpsl
$(PKG)_DESCR    := C library for the Public Suffix List
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.21.1
$(PKG)_CHECKSUM := ac6ce1e1fbd4d0254c4ddb9d37f1fa99dec83619c1253328155206b896210d4c
# Filter out releases <= 0.21.1 which used different naming
$(PKG)_GH_CONF  := rockdaboot/libpsl/releases,,,libpsl
$(PKG)_DEPS     := cc meson-wrapper glib libidn2 libxml2 sqlite

define $(PKG)_BUILD
    LDFLAGS=-liconv '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Druntime=libidn2 \
        -Dbuiltin=libidn2 \
        $(PKG_MESON_OPTS) \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
