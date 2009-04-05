# OpenEXR

PKG             := openexr
$(PKG)_VERSION  := 1.6.1
$(PKG)_CHECKSUM := b3650e6542f0e09daadb2d467425530bc8eec333
$(PKG)_SUBDIR   := openexr-$($(PKG)_VERSION)
$(PKG)_FILE     := openexr-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.openexr.com/
$(PKG)_URL      := http://download.savannah.nongnu.org/releases/openexr/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc ilmbase

define $(PKG)_UPDATE
    wget -q -O- 'http://www.openexr.com/downloads.html' | \
    grep 'openexr-' | \
    $(SED) -n 's,.*openexr-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # unpack and build a native version of ilmbase
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,ilmbase)
    cd '$(1)/$(ilmbase_SUBDIR)' && ./configure \
        --disable-shared \
        --prefix='$(1)/ilmbase' \
        --enable-threading=no \
        --disable-posix-sem
    $(MAKE) -C '$(1)/$(ilmbase_SUBDIR)' -j '$(JOBS)' install \
        bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) 's,cross_compiling=no,cross_compiling=yes,' -i '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-threading \
        --disable-posix-sem \
        --disable-ilmbasetest
    # do the first build step by hand, because a program is built that
    # generates a source file
    cd '$(1)/IlmImf' && g++ \
        -I'$(1)/ilmbase/include/OpenEXR' \
        -L'$(1)/ilmbase/lib' \
        b44ExpLogTable.cpp \
        -lImath -lHalf -lIex -lIlmThread \
        -o b44ExpLogTable
    '$(1)/IlmImf/b44ExpLogTable' > '$(1)/IlmImf/b44ExpLogTable.h'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
