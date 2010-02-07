# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# libmad
PKG             := libmad
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.15.1b
$(PKG)_CHECKSUM := cac19cd00e1a907f3150cc040ccc077783496d76
$(PKG)_SUBDIR   := libmad-$($(PKG)_VERSION)
$(PKG)_FILE     := libmad-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.underbit.com/products/mad/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/mad/libmad/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/mad/files/libmad/) | \
    $(SED) -n 's,.*libmad-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    $(SED) '/-fforce-mem/d' -i '$(1)'/configure
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
