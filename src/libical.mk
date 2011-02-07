# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# PDcurses
PKG             := libical
$(PKG)_IGNORE   := 0.46
$(PKG)_VERSION  := 0.44
$(PKG)_CHECKSUM := f781150e2d98806e91b7e0bee02abdc6baf9ac7d
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://freeassociation.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/freeassociation/$(PKG)/$(PKG)-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc pthreads

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/freeassociation/files/$(PKG)/' | \
    $(SED) -n 's,.*/$(PKG)-\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
    
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libical.exe' \
        `'$(TARGET)-pkg-config' libical --cflags --libs`
endef
