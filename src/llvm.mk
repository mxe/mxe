# This file is part of MXE.
# See index.html for further information.

PKG             := llvm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4
$(PKG)_CHECKSUM := 10b1fd085b45d8b19adb9a628353ce347bc136b8
$(PKG)_SUBDIR   := llvm-$($(PKG)_VERSION)
$(PKG)_FILE     := llvm-$($(PKG)_VERSION).src.tar.gz
$(PKG)_URL      := http://llvm.org/releases/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://llvm.org/releases/download.html' | \
    grep 'Download LLVM' | \
    $(SED) -n 's,.*\([0-9]\.[0-9]\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DLIBTYPE=STATIC \
        -DLLVM_BUILD_TOOLS=OFF
    $(MAKE) -C '$(1)/build' -j $(JOBS) llvm-tblgen
    $(MAKE) -C '$(1)/build' -j $(JOBS) intrinsics_gen
    $(MAKE) -C '$(1)/build' -j $(JOBS) install
    ln -sf '$(PREFIX)/$(TARGET)/bin/llvm-config' '$(PREFIX)/bin/$(TARGET)-llvm-config'
endef

$(PKG)_BUILD_SHARED =
