# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libidn
$(PKG)_WEBSITE  := https://www.gnu.org/software/libidn/
$(PKG)_DESCR    := Libidn
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.33
$(PKG)_CHECKSUM := 44a7aab635bb721ceef6beecc4d49dfd19478325e1b47f3196f7d2acc4930e19
$(PKG)_SUBDIR   := libidn-$($(PKG)_VERSION)
$(PKG)_FILE     := libidn-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/libidn/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftpmirror.gnu.org/libidn/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gettext libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://git.savannah.gnu.org/gitweb/?p=libidn.git;a=tags' | \
    grep '<a class="list subject"' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9][^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && rm aclocal.m4 && autoreconf -fi
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
