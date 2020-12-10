# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := readline
$(PKG)_WEBSITE  := https://tiswww.case.edu/php/chet/readline/rltop.html
$(PKG)_DESCR    := Readline
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.1
$(PKG)_CHECKSUM := f8ceb4ee131e3232226a17f51b164afc46cd0b9e6cef344be87c65962cb82b02
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
        --enable-multibyte \
        --without-purify \
        --without-curses
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
