# gettext

PKG            := gettext
$(PKG)_VERSION := 0.17
$(PKG)_SUBDIR  := gettext-$($(PKG)_VERSION)
$(PKG)_FILE    := gettext-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE := http://www.gnu.org/software/gettext/
$(PKG)_URL     := ftp://ftp.gnu.org/pub/gnu/gettext/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc libiconv

define $(PKG)_UPDATE
    wget -q -O- 'http://www.gnu.org/software/gettext/' | \
    grep 'gettext-' | \
    $(SED) -n 's,.*gettext-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # native build of libiconv (used by gettext-tools)
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,libiconv)
    cd '$(1)/$(libiconv_SUBDIR)' && ./configure \
        --prefix='$(1)/libiconv' \
        --disable-shared \
        --disable-nls
    $(MAKE) -C '$(1)/$(libiconv_SUBDIR)' -j 1 install

    # native build for gettext-tools
    cd '$(1)/gettext-tools' && ./configure \
        --disable-shared \
        --prefix='$(PREFIX)' \
        --disable-threads \
        --with-libiconv-prefix='$(1)/libiconv' \
        --with-included-gettext \
        --with-included-glib \
        --with-included-libcroco \
        --with-included-libxml \
        --with-included-regex \
        --without-libpth-prefix \
        --without-libncurses-prefix \
        --without-libtermcap-prefix \
        --without-libxcurses-prefix \
        --without-libcurses-prefix \
        --without-libexpat-prefix \
        --without-emacs
    $(MAKE) -C '$(1)/gettext-tools' -j '$(JOBS)' SHELL=bash
    $(MAKE) -C '$(1)/gettext-tools/src' -j 1 SHELL=bash lib_LTLIBRARIES= install-binPROGRAMS

    # cross build for gettext-runtime
    cd '$(1)/gettext-runtime' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-threads=win32 \
        --without-libexpat-prefix \
        --without-libxml2-prefix
    $(MAKE) -C '$(1)/gettext-runtime/intl' -j '$(JOBS)' SHELL=bash install
endef
