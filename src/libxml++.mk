# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libxml++
$(PKG)_WEBSITE  := https://libxmlplusplus.sourceforge.io/
$(PKG)_DESCR    := libxml++
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.6.1
$(PKG)_CHECKSUM := 4996e8a73995e8a4cd656c8591dce38181146edfc30cb47c97d1db3c56990ad7
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
        -Dbuild-examples=false \
        '$(BUILD_DIR)' '$(SOURCE_DIR)' && \
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' && \
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
