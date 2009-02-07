# giflib
# http://sourceforge.net/projects/libungif/

PKG            := giflib
$(PKG)_VERSION := 4.1.6
$(PKG)_SUBDIR  := giflib-$($(PKG)_VERSION)
$(PKG)_FILE    := giflib-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL     := http://$(SOURCEFORGE_MIRROR)/giflib/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=102202&package_id=119585' | \
    grep 'giflib-' | \
    $(SED) -n 's,.*giflib-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --without-x
    $(MAKE) -C '$(1)/lib' -j '$(JOBS)' install
endef
