# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := lzma
$(PKG)_WEBSITE  := http://www.7-zip.org/sdk.html
$(PKG)_DESCR    := LZMA SDK
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1701
$(PKG)_CHECKSUM := 0daa0a15a3a2b6a8c9459744e4a25f7a26fdae0e9e406e0ac0809c3fbbacf2e4
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := lzma$(subst .,,$($(PKG)_VERSION)).7z
$(PKG)_URL      := http://www.7-zip.org/a/$($(PKG)_FILE)
$(PKG)_DEPS     := cc
$(PKG)_DEPS_$(BUILD) :=
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.7-zip.org/sdk.html' | \
    $(SED) -n 's,.*lzma\([0-9][^"]*\)\.7z.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(MAKE) all -C '$(1)/C/Util/Lzma' \
        -f makefile.gcc -j '$(JOBS)' \
        'PROG=lzma.exe' \
        'CC=$(TARGET)-gcc' \
        'CXX=$(TARGET)-g++' \
        'LD=$(TARGET)-ld' \
        'AR=$(TARGET)-ar' \
        'PKG_CONFIG=$(TARGET)-pkg-config'
    $(MAKE) all -C '$(1)/CPP/7zip/Bundles/LzmaCon' \
        -f makefile.gcc -j '$(JOBS)' \
        'IS_MINGW=1' \
        'PROG=lzma.exe' \
        'CXX=$(TARGET)-g++ -O2 -Wall' \
        'CXX_C=$(TARGET)-gcc -O2 -Wall' \
        'CC=$(TARGET)-gcc' \
        'LD=$(TARGET)-ld' \
        'AR=$(TARGET)-ar' \
        'PKG_CONFIG=$(TARGET)-pkg-config'
    cp '$(1)/C/Util/Lzma/lzma.exe' \
        '$(PREFIX)/$(TARGET)/bin/lzma.exe'
    cp '$(1)/CPP/7zip/Bundles/LzmaCon/lzma.exe' \
        '$(PREFIX)/$(TARGET)/bin/lzma-cxx.exe'
endef

$(PKG)_BUILD_$(BUILD) :=
