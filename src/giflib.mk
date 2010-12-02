# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# giflib
PKG             := giflib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.1.6
$(PKG)_CHECKSUM := 22680f604ec92065f04caf00b1c180ba74fb8562
$(PKG)_SUBDIR   := giflib-$($(PKG)_VERSION)
$(PKG)_FILE     := giflib-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://sourceforge.net/projects/libungif/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/giflib/giflib 4.x/giflib-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/giflib/files/giflib 4.x/' | \
    $(SED) -n 's,.*/giflib-\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --without-x \
        CPPFLAGS='-D_OPEN_BINARY'
    $(MAKE) -C '$(1)/lib' -j '$(JOBS)' install
endef
