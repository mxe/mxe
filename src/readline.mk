# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := readline
$(PKG)_WEBSITE  := https://tiswww.case.edu/php/chet/readline/rltop.html
$(PKG)_DESCR    := GNU Readline library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.3
$(PKG)_CHECKSUM := fe5383204467828cd495ee8d1d3c037a7eba1389c22bc6a041f627976f9061cc
$(PKG)_SUBDIR   := readline-$($(PKG)_VERSION)
$(PKG)_FILE     := readline-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/readline/$($(PKG)_FILE)
$(PKG)_DEPS     := cc termcap

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://tiswww.case.edu/php/chet/readline/rltop.html' | \
    grep 'readline-' | \
    $(SED) -n 's,.*readline-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && bash_cv_wcwidth_broken=no \
        ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-install-examples \
        --enable-multibyte \
        --without-curses
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
