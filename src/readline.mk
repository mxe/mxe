# This file is part of MXE.
# See index.html for further information.

PKG             := readline
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.3
$(PKG)_CHECKSUM := 017b92dc7fd4e636a2b5c9265a77ccc05798c9e1
$(PKG)_SUBDIR   := readline-$($(PKG)_VERSION)
$(PKG)_FILE     := readline-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnu.org/gnu/readline/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc pdcurses

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://tiswww.case.edu/php/chet/readline/rltop.html' | \
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
        --with-curses \
        LIBS='-lcurses'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(if $(BUILD_STATIC),SHARED_LIBS=,SHLIB_LIBS='-lcurses')
endef
