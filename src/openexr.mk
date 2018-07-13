# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := openexr
$(PKG)_WEBSITE  := https://www.openexr.com/
$(PKG)_DESCR    := OpenEXR
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.0
$(PKG)_CHECKSUM := 36a012f6c43213f840ce29a8b182700f6cf6b214bea0d5735594136b44914231
$(PKG)_SUBDIR   := openexr-$($(PKG)_VERSION)
$(PKG)_FILE     := openexr-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://download.savannah.nongnu.org/releases/openexr/$($(PKG)_FILE)
$(PKG)_DEPS     := cc ilmbase pthreads zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.openexr.com/downloads.html' | \
    grep 'openexr-' | \
    $(SED) -n 's,.*openexr-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # Update auto-stuff, except autoheader, because if fails...
    cd '$(1)' && AUTOHEADER=true autoreconf -fi
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
        $(MXE_CONFIGURE_OPTS) \
        --disable-threading \
        --disable-posix-sem \
        --disable-ilmbasetest \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        CXXFLAGS="-g -O2"
    # build the code generator manually
    cd '$(1)/IlmImf' && $(BUILD_CXX) -O2 \
        -I'$(1)/ilmbase/include/OpenEXR' \
        -L'$(1)/ilmbase/lib' \
        b44ExpLogTable.cpp \
        -lHalf \
        -o b44ExpLogTable
    '$(1)/IlmImf/b44ExpLogTable' > '$(1)/IlmImf/b44ExpLogTable.h'
    cd '$(1)/IlmImf' && $(BUILD_CXX) -O2 \
        -I'$(1)/config' -I. \
        -I'$(1)/ilmbase/include/OpenEXR' \
        -L'$(1)/ilmbase/lib' \
        dwaLookups.cpp \
        -lHalf -lIlmThread -lIex -lpthread \
        -o dwaLookups
    '$(1)/IlmImf/dwaLookups' > '$(1)/IlmImf/dwaLookups.h'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-g++' \
        -Wall -Wextra -std=gnu++0x \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-openexr.exe' \
        `'$(TARGET)-pkg-config' OpenEXR --cflags --libs`
endef
