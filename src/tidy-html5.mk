# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := tidy-html5
$(PKG)_WEBSITE  := http://www.html-tidy.org/
$(PKG)_DESCR    := HTML/XML syntax checker and reformatter
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.4.0
$(PKG)_CHECKSUM := a2d754b7349982e33f12d798780316c047a3b264240dc6bbd4641542e57a0b7a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/htacg/tidy-html5/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/htacg/tidy-html5/releases' | \
    $(SED) -n 's,.*/htacg/tidy-html5/archive/\([0-9][^>]*\)\.tar\.gz.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && $(TARGET)-cmake '$(1)' \
        -DTIDY_COMPAT_HEADERS:BOOL=YES \
        -DBUILD_SHARED_LIB=$(CMAKE_SHARED_BOOL)
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install

    $(if $(BUILD_STATIC),
        cd '$(PREFIX)/$(TARGET)/lib' && mv libtidys.a libtidy.a,
        rm -f '$(PREFIX)/$(TARGET)/lib/libtidys.a')
endef
