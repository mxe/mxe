# This file is part of MXE.
# See index.html for further information.

PKG             := libxslt
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 69f74df8228b504a87e2b257c2d5238281c65154
$(PKG)_SUBDIR   := libxslt-$($(PKG)_VERSION)
$(PKG)_FILE     := libxslt-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://xmlsoft.org/libxslt/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libxml2 libgcrypt

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/browse/libxslt/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=v\\([0-9][^']*\\)'.*,\\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        $(LINK_STYLE) \
        --without-debug \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-libxml-prefix='$(PREFIX)/$(TARGET)' \
        LIBGCRYPT_CONFIG='$(PREFIX)/$(TARGET)/bin/libgcrypt-config' \
        --without-python \
        --without-plugins
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

$(PKG)_BUILD_i686-static-mingw32    = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-static-mingw32  =
$(PKG)_BUILD_i686-dynamic-mingw32   = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-dynamic-mingw32 = $($(PKG)_BUILD)
