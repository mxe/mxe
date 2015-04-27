# This file is part of MXE.
# See index.html for further information.

PKG             := miniupnpc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9
$(PKG)_CHECKSUM := 643001d52e322c52a7c9fdc8f31a7920f4619fc0
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://miniupnp.free.fr/files/$($(PKG)_FILE)
$(PKG)_URL_2    := http://miniupnp.tuxfamily.org/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

# We can build the whole package, but only make libminiupnpc.a. Rest makes little sense.
define $(PKG)_BUILD
    cd '$(1)' && $(SH) ./updateminiupnpcstrings.sh
    $(MAKE) -C '$(1)' -f Makefile.mingw -j '$(JOBS)' \
        CC='$(TARGET)-gcc' \
        AR='$(TARGET)-ar' \
        RANLIB='$(TARGET)-ranlib' \
        DLLWRAP='$(TARGET)-dllwrap' \
        init libminiupnpc.a
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libminiupnpc.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/miniupnpc'
    $(INSTALL) -m644 '$(1)/bsdqueue.h' '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/declspec.h' '$(PREFIX)/$(TARGET)/include/miniupnpc/'
    $(INSTALL) -m644 '$(1)/igd_desc_parse.h' '$(PREFIX)/$(TARGET)/include/miniupnpc/'
    $(INSTALL) -m644 '$(1)/miniupnpc.h' '$(PREFIX)/$(TARGET)/include/miniupnpc/'
    $(INSTALL) -m644 '$(1)/miniupnpctypes.h' '$(PREFIX)/$(TARGET)/include/miniupnpc/'
    $(INSTALL) -m644 '$(1)/miniwget.h' '$(PREFIX)/$(TARGET)/include/miniupnpc/'
    $(INSTALL) -m644 '$(1)/portlistingparse.h' '$(PREFIX)/$(TARGET)/include/miniupnpc/'
    $(INSTALL) -m644 '$(1)/upnpcommands.h' '$(PREFIX)/$(TARGET)/include/miniupnpc/'
    $(INSTALL) -m644 '$(1)/upnperrors.h' '$(PREFIX)/$(TARGET)/include/miniupnpc/'
    $(INSTALL) -m644 '$(1)/upnpreplyparse.h' '$(PREFIX)/$(TARGET)/include/miniupnpc/'
endef
