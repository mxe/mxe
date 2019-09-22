# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := openexr
$(PKG)_WEBSITE  := https://www.openexr.com/
$(PKG)_DESCR    := OpenEXR
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.0
$(PKG)_CHECKSUM := fd6cb3a87f8c1a233be17b94c74799e6241d50fc5efd4df75c7a4b9cf4e25ea6
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

GCC_VERSION_MAJOR := $(shell echo $(gcc_VERSION) | cut -f1 -d.)
GCC_VERSION_MINOR := $(shell echo $(gcc_VERSION) | cut -f2 -d.)

$(PKG)_CXXSTD_14 := $(shell [ $(GCC_VERSION_MAJOR) -gt 6 -o \( $(GCC_VERSION_MAJOR) -eq 6 -a $(GCC_VERSION_MINOR) -ge 1 \) ] && echo true)

define $(PKG)_BUILD
    # Update auto-stuff, except autoheader, because if fails...
    cd '$(1)' && AUTOHEADER=true autoreconf -fi
    # unpack and build a native version of ilmbase
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,ilmbase)
# Don't apply ilmbase patches.
#    $(foreach PKG_PATCH,$(sort $(wildcard $(TOP_DIR)/src/ilmbase-*.patch)),
 #       (cd '$(1)/$(ilmbase_SUBDIR)' && $(PATCH) -p1 -u) < $(PKG_PATCH))
    echo 'echo $1' > '$(1)/$(ilmbase_SUBDIR)/config.sub'
    cd '$(1)/$(ilmbase_SUBDIR)' && $(SHELL) ./configure \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(1)/ilmbase' \
        --enable-threading \
        --disable-posix-sem \
        --enable-cxxstd=$(if $($(PKG)_CXXSTD_14),14,11) \
        CONFIG_SHELL=$(SHELL) \
        SHELL=$(SHELL)
    $(MAKE) -C '$(1)/$(ilmbase_SUBDIR)' -j '$(JOBS)' install \
        bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-threading \
        --disable-posix-sem \
        --enable-cxxstd=$(if $($(PKG)_CXXSTD_14),14,11) \
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
