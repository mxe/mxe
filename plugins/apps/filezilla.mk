# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := filezilla
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.30.0
$(PKG)_CHECKSUM := 910b676dd2b558a7c96cdbe77c2fb82df3cffd88a1b99b98b475e9c5d8c41ff0
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(PKG)-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_WEBSITE  := https://filezilla-project.org
$(PKG)_OWNER    := https://filezilla-project.org/sourcecode.php
$(PKG)_DEPS     := cc gnutls libfilezilla libidn sqlite wxwidgets 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.qbittorrent.org/download.php' | \
    $(SED) -n 's,.*qbittorrent-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && \
        ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-manualupdatecheck \
        --disable-autoupdatecheck \
        --with-pugixml=builtin'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    cp '$(1)'/src/release/filezilla.exe '$(PREFIX)/$(TARGET)/bin/'
endef

$(PKG)_BUILD_SHARED =
