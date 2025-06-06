# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libidn
$(PKG)_WEBSITE  := https://www.gnu.org/software/libidn/
$(PKG)_DESCR    := Libidn
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.43
$(PKG)_CHECKSUM := bdc662c12d041b2539d0e638f3a6e741130cdb33a644ef3496963a443482d164
$(PKG)_SUBDIR   := libidn-$($(PKG)_VERSION)
$(PKG)_FILE     := libidn-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/libidn/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftpmirror.gnu.org/libidn/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gettext libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://git.savannah.gnu.org/gitweb/?p=libidn.git;a=tags' | \
    $(SED) -n 's,.*<a[^>]*>\(libidn \)\?\([0-9][^<]*\)<.*,\2,p' | \
    head -1
endef

define $(PKG)_BUILD
    # don't build and install docs
    (echo '# DISABLED'; echo 'all:'; echo 'install:') > '$(1)/doc/Makefile.in'
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-csharp \
        --with-libiconv-prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libidn.exe' \
        `'$(TARGET)-pkg-config' libidn --cflags --libs`
endef
