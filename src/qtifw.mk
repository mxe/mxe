# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtifw
$(PKG)_WEBSITE  := https://doc.qt.io/qtinstallerframework/index.html
$(PKG)_DESCR    := Qt Installer Framework
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.4
$(PKG)_CHECKSUM := a4ecafc37086f96a833463214f873caac977199e64f0b1453aa49bdd6f24f32e
$(PKG)_SUBDIR    = qt-installer-framework-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).zip
$(PKG)_URL      := https://download.qt.io/official_releases/qt-installer-framework/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc qtbase qttools qtwinextras
$(PKG)_DEPS_$(BUILD) := qtbase qttools
# requires posix toolchain and only makes sense for static builds
$(PKG)_TARGETS  := $(BUILD) $(foreach TGT,$(MXE_TARGETS),$(and $(findstring static,$(TGT)),$(findstring posix,$(TGT)),$(TGT)))

define $(PKG)_BUILD_$(BUILD)
    cd '$(1)' && $(TARGET)-qmake-qt5
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(INSTALL) -m755 '$(1)/bin/binarycreator' '$(PREFIX)/bin/$(TARGET)-binarycreator'
    $(INSTALL) -m755 '$(1)/bin/repogen' '$(PREFIX)/bin/$(TARGET)-repogen'
    $(INSTALL) -m755 '$(1)/bin/archivegen' '$(PREFIX)/bin/$(TARGET)-archivegen'
    $(INSTALL) -m755 '$(1)/bin/devtool' '$(PREFIX)/bin/$(TARGET)-devtool'
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)' || $(MAKE) -C '$(1)' -j  1
    $(MAKE) -C '$(1)' -j 1 install
endef
