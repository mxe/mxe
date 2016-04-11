# This file is part of MXE.
# See index.html for further information.

PKG             := djvulibre
$(PKG)_IGNORE   := 3.5.27
$(PKG)_SHORTVER := 3.5.25
$(PKG)_VERSION  := $($(PKG)_SHORTVER).3
$(PKG)_CHECKSUM := 898d7ed6dd2fa311a521baa95407a91b20a872d80c45e8245442d64f142cb1e0
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_SHORTVER)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/djvu/DjVuLibre/$($(PKG)_SHORTVER)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc jpeg tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/djvu/files/DjVuLibre/' | \
    $(SED) -n 's,.*/\([0-9][^A-Za-z"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi && CPPFLAGS='-DDLL_EXPORT' ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-desktopfiles
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)/libdjvu' -j 1 install-lib \
        install-include install-pkgconfig

    '$(TARGET)-g++' \
        -W -Wall -Werror -pedantic -DDLL_EXPORT \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' ddjvuapi --libs`
endef
