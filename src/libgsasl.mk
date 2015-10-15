# This file is part of MXE.
# See index.html for further information.

PKG             := libgsasl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.0
$(PKG)_CHECKSUM := 3adfb49f9c92a719dea855fd1840d698cde55d4648d332a69032ba8bea207720
$(PKG)_SUBDIR   := libgsasl-$($(PKG)_VERSION)
$(PKG)_FILE     := libgsasl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnu.org/gnu/gsasl/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libgcrypt libiconv libidn libntlm

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.savannah.gnu.org/gitweb/?p=gsasl.git;a=tags' | \
    grep '<a class="list subject"' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9]*\.[0-9]*[02468]\.[^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && touch src/libgsasl-7.def && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-nls \
        --with-libgcrypt \
        --with-libiconv-prefix='$(PREFIX)/$(TARGET)' \
        --with-libidn-prefix='$(PREFIX)/$(TARGET)' \
        --with-libntlm-prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libgsasl.exe' \
        `'$(TARGET)-pkg-config' libgsasl --cflags --libs`
endef
