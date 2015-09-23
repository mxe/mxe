# This file is part of MXE.
# See index.html for further information.

PKG             := plotutils
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.6
$(PKG)_CHECKSUM := 4f4222820f97ca08c7ea707e4c53e5a3556af4d8f1ab51e0da6ff1627ff433ab
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftpmirror.gnu.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := http://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libpng pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/plotutils/?C=M;O=D' | \
    grep '<a href="plotutils-' | \
    $(SED) -n 's,.*plotutils-\([0-9][^<]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --disable-shared \
        --enable-libplotter \
        --enable-libxmi \
        --with-png \
        --without-x \
        CFLAGS='-DNO_SYSTEM_GAMMA'
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS= INFO_DEPS=
endef

$(PKG)_BUILD_SHARED =
