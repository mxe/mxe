# This file is part of MXE.
# See index.html for further information.

PKG             := gsl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.16
$(PKG)_CHECKSUM := 210af9366485f149140973700d90dc93a4b6213e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/$(PKG)/' | \
    $(SED) -n 's,.*<a href="gsl-\([0-9.]\+\).tar.gz".*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --enable-static
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-gsl.exe' \
        -lgsl
endef

$(PKG)_BUILD_SHARED =
