# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# lcms
PKG             := lcms
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.19
$(PKG)_CHECKSUM := d5b075ccffc0068015f74f78e4bc39138bcfe2d4
$(PKG)_SUBDIR   := lcms-$(subst a,,$($(PKG)_VERSION))
$(PKG)_FILE     := lcms-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.littlecms.com/
$(PKG)_URL      := http://www.littlecms.com/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc jpeg tiff zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://www.littlecms.com/downloads.htm' | \
    grep 'lcms-' | \
    $(SED) -n 's,.*lcms-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
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
