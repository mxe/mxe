# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# llvm
PKG             := llvm
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 3.0
$(PKG)_CHECKSUM := b683e7294fcf69887c0d709025d4640f5dca755b
$(PKG)_SUBDIR   := llvm-$($(PKG)_VERSION).src
$(PKG)_FILE     := llvm-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://llvm.org
$(PKG)_URL      := http://llvm.org/releases/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://llvm.org/releases/download.html' | \
    grep 'Download LLVM' | \
    $(SED) -n 's,.*\([0-9]\.[0-9]\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DLIBTYPE=STATIC \
        -DLLVM_TARGETS_TO_BUILD="X86;" \
        -DLLVM_BUILD_TOOLS=OFF
    $(MAKE) -C '$(1)/build' -j $(JOBS) llvm-tblgen
    $(MAKE) -C '$(1)/build' -j $(JOBS) intrinsics_gen
    $(MAKE) -C '$(1)/build' -j $(JOBS) install
    ln -sf '$(PREFIX)/$(TARGET)/bin/llvm-config' '$(PREFIX)/bin/$(TARGET)-llvm-config'
endef
