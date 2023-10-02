# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := fribidi
$(PKG)_WEBSITE  := https://fribidi.org/
$(PKG)_DESCR    := FriBidi
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.13
$(PKG)_CHECKSUM := 7fa16c80c81bd622f7b198d31356da139cc318a63fc7761217af4130903f54a2
$(PKG)_GH_CONF  := fribidi/fribidi/releases,v,,,,.tar.xz
$(PKG)_DEPS     := cc meson-wrapper

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) -Dtests=false -Ddocs=false '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
