# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libmodplug
$(PKG)_WEBSITE  := https://modplug-xmms.sourceforge.io/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.8.9.0
$(PKG)_CHECKSUM := 457ca5a6c179656d66c01505c0d95fafaead4329b9dbaa0f997d00a3508ad9de
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/modplug-xmms/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/modplug-xmms/files/libmodplug/' | \
    $(SED) -n 's,.*/projects/.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libmodplug.exe' \
        `'$(TARGET)-pkg-config' libmodplug --cflags --libs`
endef
