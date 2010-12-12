# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# muParser
PKG             := muparser
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.34
$(PKG)_CHECKSUM := d6d834d3ba2bd3c316c9b3070369d32701703f78
$(PKG)_SUBDIR   := $(PKG)_v$(subst .,,$($(PKG)_VERSION))
$(PKG)_FILE     := $(PKG)_v$(subst .,,$($(PKG)_VERSION)).tar.gz
$(PKG)_WEBSITE  := http://$(PKG).sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/Version $($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/muparser/files/muparser/' | \
    $(SED) -n 's,.*Version%20\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-samples \
        --disable-debug
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
