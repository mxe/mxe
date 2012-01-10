# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# Libidn
PKG             := libidn
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.24
$(PKG)_CHECKSUM := 4251c108966375ede4df15d76a1bd9a4440f44ee
$(PKG)_SUBDIR   := libidn-$($(PKG)_VERSION)
$(PKG)_FILE     := libidn-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.gnu.org/software/libidn/
$(PKG)_URL      := ftp://ftp.gnu.org/gnu/libidn/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gettext libiconv

define $(PKG)_UPDATE
    wget -q -O- 'http://git.savannah.gnu.org/gitweb/?p=libidn.git;a=tags' | \
    grep '<a class="list subject"' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9][^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --disable-csharp \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-libiconv-prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libidn.exe' \
        `'$(TARGET)-pkg-config' libidn --cflags --libs`
endef
