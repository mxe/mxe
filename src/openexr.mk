# This file is part of MXE.
# See index.html for further information.

PKG             := openexr
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 774ae69ac01bbe4443b6fa0a9b12e276d0af44f5
$(PKG)_SUBDIR   := openexr-$($(PKG)_VERSION)
$(PKG)_FILE     := openexr-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.savannah.nongnu.org/releases/openexr/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc ilmbase pthreads zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.openexr.com/downloads.html' | \
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
        CONFIG_SHELL=$(SHELL) \
        SHELL=$(SHELL)
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
        -lImath -lHalf -lIex -lIlmThread -lpthread \
        -o b44ExpLogTable
    '$(1)/IlmImf/b44ExpLogTable' > '$(1)/IlmImf/b44ExpLogTable.h'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-g++' \
        -Wall -Wextra -std=gnu++0x \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-openexr.exe' \
        `'$(TARGET)-pkg-config' OpenEXR --cflags --libs`
endef
