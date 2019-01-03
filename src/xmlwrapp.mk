# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := xmlwrapp
$(PKG)_WEBSITE  := https://sourceforge.net/projects/xmlwrapp/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.7.0
$(PKG)_CHECKSUM := 2d46234058270d878e7674f4ff9005a4ebd4e991162de9d1215d33d99fde37aa
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc boost libxml2 libxslt

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/xmlwrapp/files/xmlwrapp/' | \
    $(SED) -n 's,.*/projects/.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        PKG_CONFIG='$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= html_DATA=
endef

$(PKG)_BUILD_SHARED =
