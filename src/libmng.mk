# This file is part of MXE.
# See index.html for further information.

PKG             := libmng
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := c21c84b614500ae1a41c6595d5f81c596e406ca2
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)-devel/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib jpeg lcms1

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/libmng/files/libmng-devel/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)' \
        -f '$(1)'/makefiles/makefile.unix \
        CC=$(TARGET)-gcc CFLAGS='-DMNG_BUILD_SO -DMNG_FULL_CMS'
    $(TARGET)-ranlib '$(1)/libmng.a'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libmng.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/libmng.h' '$(1)/libmng_conf.h' '$(1)/libmng_types.h' '$(PREFIX)/$(TARGET)/include/'
    $(SED) -e 's^@prefix@^$(PREFIX)/$(TARGET)^;' \
           -e 's^@VERSION@^$(libmng_VERSION)^;' \
           -e 's^@mng_libs_private@^-ljpeg^;' \
           -e 's^@mng_requires_private@^lcms zlib^;' \
           < '$(1)/libmng.pc.in' > '$(1)/libmng.pc'
    $(INSTALL) -m644 '$(1)/libmng.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig/'
endef
