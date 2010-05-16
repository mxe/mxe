# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# lcms
PKG             := lcms
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0a
$(PKG)_CHECKSUM := b9d3939764e3b3f33cb9b9f7cffd43520227db9e
$(PKG)_SUBDIR   := lcms-$(subst a,,$($(PKG)_VERSION))
$(PKG)_FILE     := lcms$(word 1,$(subst ., ,$($(PKG)_VERSION)))-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.littlecms.com/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(subst a,,$($(PKG)_VERSION))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc jpeg tiff zlib

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/lcms/files/) | \
    $(SED) -n 's,.*lcms[0-9]*-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --disable-shared \
        --with-jpeg \
        --with-tiff \
        --with-zlib
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=
endef
