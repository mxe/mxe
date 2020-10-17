# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := argon2
$(PKG)_WEBSITE  := https://github.com/P-H-C/phc-winner-argon2
$(PKG)_DESCR    := argon2 (aka. libargon2)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 20190702
$(PKG)_CHECKSUM := daf972a89577f8772602bf2eb38b6a3dd3d922bf5724d45e7f9589b5e830442c
$(PKG)_SUBDIR   := phc-winner-$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/P-H-C/phc-winner-argon2/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc

_march := x86_64

define $(PKG)_BUILD
    echo "Building in folder $(1) prefix=$(PREFIX)"
    $(MAKE) -C '$(1)' -j '$(JOBS)' CC=$(TARGET)-gcc AR=$(TARGET)-ar OPTTARGET=$(_march)
    $(MAKE) -C '$(1)' -j 1 install CC=$(TARGET)-gcc AR=$(TARGET)-ar OPTTARGET=$(_march) PREFIX=$(PREFIX)/$(TARGET)
endef
