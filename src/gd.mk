# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gd
$(PKG)_WEBSITE  := https://libgd.github.io/
$(PKG)_DESCR    := GD  (without support for xpm)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.5
$(PKG)_CHECKSUM := 8c302ccbf467faec732f0741a859eef4ecae22fea2d2ab87467be940842bde51
$(PKG)_SUBDIR   := libgd-$($(PKG)_VERSION)
$(PKG)_FILE     := libgd-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://github.com/libgd/libgd/releases/download/gd-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc fontconfig freetype jpeg libpng libwebp pthreads tiff

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://bitbucket.org/libgd/gd-libgd/downloads/' | \
    $(SED) -n 's,.*libgd-\([0-9.]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(if $(BUILD_STATIC), $(SED) -i 's|-I@includedir@|-I@includedir@ -DNONDLL -DBGDWIN32|' '$(1)/config/gdlib-config.in')
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-freetype='$(PREFIX)/$(TARGET)' \
        --without-x \
        CFLAGS=$(if $(BUILD_STATIC),'-DNONDLL')
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-gd.exe' \
        `'$(PREFIX)/$(TARGET)/bin/gdlib-config' --cflags --libs`
endef
