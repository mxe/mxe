# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libgsasl
$(PKG)_WEBSITE  := https://www.gnu.org/software/gsasl/
$(PKG)_DESCR    := Libgsasl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.1
$(PKG)_CHECKSUM := 19e2f90525c531010918c50bb1febef0d7115d620150cc66153b9ce73ff814e6
$(PKG)_SUBDIR   := libgsasl-$($(PKG)_VERSION)
$(PKG)_FILE     := libgsasl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/gsasl/$($(PKG)_FILE)
$(PKG)_URL_2    := https://download.savannah.nongnu.org/releases/gsasl/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libgcrypt libiconv libidn libntlm

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://git.savannah.gnu.org/gitweb/?p=gsasl.git;a=tags' | \
    grep '<a [^<]*class="list subject"' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9]*\.[0-9]*[02468]\.[^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && touch src/libgsasl-7.def && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-nls \
        --with-libgcrypt \
        --with-libgcrypt-prefix='$(PREFIX)/$(TARGET)' \
        --with-libiconv-prefix='$(PREFIX)/$(TARGET)' \
        --with-libidn-prefix='$(PREFIX)/$(TARGET)' \
        --with-libntlm-prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libgsasl.exe' \
        `'$(TARGET)-pkg-config' libgsasl --cflags --libs`
endef
