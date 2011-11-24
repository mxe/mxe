# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# llvm
PKG             := llvm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.8
$(PKG)_CHECKSUM := 6d49fe039d28e8664de25491c775cb2c599e30c1
$(PKG)_SUBDIR   := llvm-$($(PKG)_VERSION)
$(PKG)_FILE     := llvm-$($(PKG)_VERSION).tgz
$(PKG)_WEBSITE  := http://llvm.org
$(PKG)_URL      := http://llvm.org/releases/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package llvm.' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DLIBTYPE=STATIC
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install
endef
