# giflib

PKG             := giflib
$(PKG)_VERSION  := 4.1.6
$(PKG)_CHECKSUM := 22680f604ec92065f04caf00b1c180ba74fb8562
$(PKG)_SUBDIR   := giflib-$($(PKG)_VERSION)
$(PKG)_FILE     := giflib-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://sourceforge.net/projects/libungif/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/giflib/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/giflib/files/giflib 4.x/) | \
    $(SED) -n 's,.*giflib-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --without-x
    $(MAKE) -C '$(1)/lib' -j '$(JOBS)' install
endef
