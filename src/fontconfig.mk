# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# fontconfig
PKG             := fontconfig
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.8.0
$(PKG)_CHECKSUM := 570fb55eb14f2c92a7b470b941e9d35dbfafa716
$(PKG)_SUBDIR   := fontconfig-$($(PKG)_VERSION)
$(PKG)_FILE     := fontconfig-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://fontconfig.org/
$(PKG)_URL      := http://fontconfig.org/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc freetype expat

define $(PKG)_UPDATE
    wget -q -O- 'http://fontconfig.org/release/' | \
    $(SED) -n 's,.*fontconfig-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    # ensure there is no (buggy) attempt to install the *.dll.a file
    # (remove this line of you want to link dynamically)
    $(SED) -i 's,^install-data-local:.*,install-data-local:,' '$(1)/src/Makefile.in'
    $(SED) -i 's,^\(Libs:.*\),\1 @EXPAT_LIBS@ @FREETYPE_LIBS@,' '$(1)/fontconfig.pc.in'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-arch='$(TARGET)' \
        --with-freetype-config='$(PREFIX)/$(TARGET)/bin/freetype-config' \
        --with-expat='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
