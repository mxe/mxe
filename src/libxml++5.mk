# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libxml++5
$(PKG)_WEBSITE  := https://libxmlplusplus.github.io/libxmlplusplus/
$(PKG)_DESCR    := libxml++5
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.6.0
$(PKG)_CHECKSUM := cd01ad15a5e44d5392c179ddf992891fb1ba94d33188d9198f9daf99e1bc4fec
$(PKG)_SUBDIR   := libxml++-$($(PKG)_VERSION)
$(PKG)_FILE     := libxml++-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://github.com/libxmlplusplus/libxmlplusplus/releases/download/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper libxml2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/libxmlplusplus/libxmlplusplus/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\?\([0-9]\+\.[0-9.]\+\)<.*,\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        '$(BUILD_DIR)' '$(SOURCE_DIR)' && \
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' && \
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
