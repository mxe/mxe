# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := botan2
$(PKG)_WEBSITE  := https://botan.randombit.net/
$(PKG)_DESCR    := botan2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.19.5
$(PKG)_CHECKSUM := dfeea0e0a6f26d6724c4af01da9a7b88487adb2d81ba7c72fcaf52db522c9ad4
$(PKG)_SUBDIR   := Botan-$($(PKG)_VERSION)
$(PKG)_FILE     := Botan-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://botan.randombit.net/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
     $(WGET) -q -O- 'https://botan.randombit.net/releases/' | \
     grep 'a href="Botan-2' | \
     $(SED) 's/.*Botan-\(2.[0-9.]*\)\..*/\1/' | \
     $(SORT) -Vr | \
     head -1
endef

# libbotan uses a custom made configure script that doesn't recognize
# the option --host and fails on unknown options.
# Therefor $(MXE_CONFIGURE_OPTS) can't be used here.
define $(PKG)_BUILD
    cd '$(1)' && ./configure.py \
        --prefix=$(PREFIX)/$(TARGET) \
        --os=mingw \
        --cpu=x86_$(if $(findstring x86_64,$(TARGET)),64,32) \
        --cc-bin=$(TARGET)-g++ \
        --ar-command=$(TARGET)-ar \
        --without-os-feature=threads \
        $(if $(BUILD_SHARED), \
            --enable-shared --disable-static \
          ,\
            --disable-shared --enable-static \
        )
        # Note: libbotan doesn't currently support shared libraries with mingw,
        #       but if that ever changes, we'll have the code in place to
        #       configure the library to take advantage of this
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

$(PKG)_BUILD_SHARED =
