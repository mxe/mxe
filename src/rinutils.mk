# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := rinutils
$(PKG)_WEBSITE  := https://github.com/shlomif/rinutils
$(PKG)_DESCR    := Rinutils
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.10.3
$(PKG)_CHECKSUM := f9e527d37a6cc8c7b8870ada63caa24f32ab0d29fd1116df3ebb686583030955
$(PKG)_GH_CONF  := shlomif/rinutils/releases,,,,,.tar.xz
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
