# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := lzma
$(PKG)_WEBSITE  := https://www.7-zip.org/sdk.html
$(PKG)_DESCR    := LZMA SDK
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2102
$(PKG)_CHECKSUM := 299c435e5b97c0419deac0afd1df1b5fa8618ecb166d1d38621b3f78bec22d75
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := lzma$(subst .,,$($(PKG)_VERSION)).7z
$(PKG)_URL      := https://www.7-zip.org/a/$($(PKG)_FILE)
$(PKG)_DEPS     := cc
$(PKG)_DEPS_$(BUILD) :=
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.7-zip.org/sdk.html' | \
    $(SED) -n 's,.*lzma\([0-9][^"]*\)\.7z.*,\1,p' | \
    head -1
endef

# liblzma is actually installed by xz
# https://github.com/mxe/mxe/issues/1481
define $(PKG)_BUILD
    $(MAKE) all -C '$(1)/C/Util/Lzma' \
        -f makefile.gcc -j '$(JOBS)' \
        'PROG=lzma.exe' \
        'CC=$(TARGET)-gcc' \
        'CXX=$(TARGET)-g++' \
        'LD=$(TARGET)-ld' \
        'AR=$(TARGET)-ar' \
        'PKG_CONFIG=$(TARGET)-pkg-config'
    cp '$(1)/C/Util/Lzma/_o/lzma.exe' \
        '$(PREFIX)/$(TARGET)/bin/lzma.exe'
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
    cp '$(1)/CPP/7zip/Bundles/LzmaCon/_o/lzma.exe.exe' \
        '$(PREFIX)/$(TARGET)/bin/lzma-cxx.exe'
endef

$(PKG)_BUILD_$(BUILD) :=
