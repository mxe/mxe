# This file is part of MXE.
# See index.html for further information.

PKG             := llvm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4
$(PKG)_CHECKSUM := 25a5612d692c48481b9b397e2b55f4870e447966d66c96d655241702d44a2628
$(PKG)_SUBDIR   := llvm-$($(PKG)_VERSION)
$(PKG)_FILE     := llvm-$($(PKG)_VERSION).src.tar.gz
$(PKG)_URL      := http://llvm.org/releases/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://llvm.org/releases/download.html' | \
    grep 'Download LLVM' | \
    $(SED) -n 's,.*LLVM \([0-9][^<]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DLIBTYPE=$(if $(BUILD_STATIC),STATIC,SHARED) \
        -DBUILD_SHARED_LIBS=$(if $(BUILD_STATIC),OFF,ON) \
        -DLLVM_BUILD_TOOLS=OFF
    $(MAKE) -C '$(1)/build' -j $(JOBS) llvm-tblgen
    $(MAKE) -C '$(1)/build' -j $(JOBS) intrinsics_gen
    $(MAKE) -C '$(1)/build' -j $(JOBS) install
    cp '$(1)'/build/bin/*.dll '$(PREFIX)/$(TARGET)/bin/'
endef
