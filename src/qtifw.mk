# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtifw
$(PKG)_WEBSITE  := https://doc.qt.io/qtinstallerframework/index.html
$(PKG)_DESCR    := Qt Installer Framework
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.1
$(PKG)_CHECKSUM := 59b5370aaf521bb1a34a025ac451bb3bbbfa519ee271156aba9d42ee1132d1b1
# the archive is in fact only a tar file, not a tar.gz
$(PKG)_FILE     := qtifw-$($(PKG)_VERSION).tar
$(PKG)_URL      := https://download.qt.io/official_releases/qt-installer-framework/$($(PKG)_VERSION)/qt-installer-framework-opensource-src-$($(PKG)_VERSION).tar.gz
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

$(PKG)_DEPS_$(BUILD) := cc qtbase qttools
$(PKG)_DEPS_STATIC   := $($(PKG)_DEPS_$(BUILD)) qtwinextras $(BUILD)~$(PKG)

define $(PKG)_BUILD_$(BUILD)
    cd '$(1)' && $(TARGET)-qmake-qt5
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(INSTALL) -m755 '$(1)/bin/binarycreator' '$(PREFIX)/bin/$(TARGET)-binarycreator'
    $(INSTALL) -m755 '$(1)/bin/repogen' '$(PREFIX)/bin/$(TARGET)-repogen'
    $(INSTALL) -m755 '$(1)/bin/archivegen' '$(PREFIX)/bin/$(TARGET)-archivegen'
    $(INSTALL) -m755 '$(1)/bin/devtool' '$(PREFIX)/bin/$(TARGET)-devtool'
endef

# only makes sense for static builds
define $(PKG)_BUILD_STATIC
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)' || $(MAKE) -C '$(1)' -j  1
    $(MAKE) -C '$(1)' -j 1 install

    # build the tutorial installer in /tmp, because the binarycreator internal rename will fail if /tmp is not in the same filesystem as mxe
    cd '$(1)examples/tutorial' && '$(PREFIX)/bin/$(BUILD)-binarycreator' -c config/config.xml -p packages -t $(PREFIX)/$(TARGET)/qt5/bin/installerbase.exe /tmp/test-$(PKG)-tutorialinstaller.exe && mv /tmp/test-$(PKG)-tutorialinstaller.exe $(PREFIX)/$(TARGET)/bin/test-$(PKG)-tutorialinstaller.exe
endef
