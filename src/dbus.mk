# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := dbus
$(PKG)_WEBSITE  := https://dbus.freedesktop.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.16.2
$(PKG)_CHECKSUM := 0ba2a1a4b16afe7bceb2c07e9ce99a8c2c3508e5dec290dbb643384bd6beb7e2
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://$(PKG).freedesktop.org/releases/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc expat meson-wrapper

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://cgit.freedesktop.org/dbus/dbus/refs/tags' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?h=dbus-\\([0-9][^']*\\)'.*,\\1,p" | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    CFLAGS='$(CFLAGS) -DPROCESS_QUERY_LIMITED_INFORMATION=0x1000' \
    '$(MXE_MESON_WRAPPER)' \
        $(MXE_MESON_OPTS) \
        -Dmodular_tests=disabled \
        -Dverbose_mode=false \
        -Dasserts=false \
        -Dlaunchd=disabled \
        -Ddoxygen_docs=disabled \
        -Dxml_docs=disabled \
        '$(BUILD_DIR)' '$(1)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
