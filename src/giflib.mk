# This file is part of MXE.
# See index.html for further information.

PKG             := giflib
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := bc942711f75de7d8539f79be34d69c0d53c381c1
$(PKG)_SUBDIR   := giflib-$($(PKG)_VERSION)
$(PKG)_FILE     := giflib-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/giflib/giflib-4.x/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/giflib/files/giflib 4.x/' | \
    $(SED) -n 's,.*/giflib-\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --without-x \
        CPPFLAGS='-D_OPEN_BINARY'
    $(MAKE) -C '$(1)/lib' -j '$(JOBS)' install
endef
