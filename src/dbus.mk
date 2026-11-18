# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := dbus
$(PKG)_WEBSITE  := https://dbus.freedesktop.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.16.4
$(PKG)_CHECKSUM := d08b05526c2cb7966a5fb79210d6112b1aca3d135f315c1b302e14b4b0297dac
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://$(PKG).freedesktop.org/releases/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc expat meson-wrapper

define $(PKG)_UPDATE
    $(call GET_LATEST_VERSION, https://dbus.freedesktop.org/releases/dbus/, dbus-, \.tar\.xz)
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
