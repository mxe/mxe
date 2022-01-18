# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := lld
$(PKG)_WEBSITE  := https://lld.llvm.org
$(PKG)_DESCR    := LLD Linker on host OS
$(PKG)_VERSION  := system

define $(PKG)_BUILD
    ln -s /usr/bin/ld.lld '$(PREFIX)/bin/$(TARGET)-ld.lld'
endef
