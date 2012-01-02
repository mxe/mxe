# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# OpenEXR
PKG             := openexr
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.7.0
$(PKG)_CHECKSUM := 91d0d4e69f06de956ec7e0710fc58ec0d4c4dc2b
$(PKG)_SUBDIR   := openexr-$($(PKG)_VERSION)
$(PKG)_FILE     := openexr-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.openexr.com/
$(PKG)_URL      := http://download.savannah.nongnu.org/releases/openexr/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc ilmbase zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://www.openexr.com/downloads.html' | \
    grep 'openexr-' | \
    $(SED) -n 's,.*openexr-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # unpack and build a native version of ilmbase
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,ilmbase)
    $(foreach PKG_PATCH,$(sort $(wildcard $(TOP_DIR)/src/ilmbase-*.patch)),
        (cd '$(1)/$(ilmbase_SUBDIR)' && $(PATCH) -p1 -u) < $(PKG_PATCH))
    echo 'echo $1' > '$(1)/$(ilmbase_SUBDIR)/config.sub'
    cd '$(1)/$(ilmbase_SUBDIR)' && $(SHELL) ./configure \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(1)/ilmbase' \
        --enable-threading=no \
        --disable-posix-sem \
        CONFIG_SHELL=$(SHELL)
    $(MAKE) -C '$(1)/$(ilmbase_SUBDIR)' -j '$(JOBS)' install \
        bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-threading \
        --disable-posix-sem \
        --disable-ilmbasetest \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config'
    # build the code generator manually
    cd '$(1)/IlmImf' && g++ \
        -I'$(1)/ilmbase/include/OpenEXR' \
        -L'$(1)/ilmbase/lib' \
        b44ExpLogTable.cpp \
        -lImath -lHalf -lIex -lIlmThread \
        -o b44ExpLogTable
    '$(1)/IlmImf/b44ExpLogTable' > '$(1)/IlmImf/b44ExpLogTable.h'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
