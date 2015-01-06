# This file is part of MXE.
# See index.html for further information.

PKG             := readline
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.2
$(PKG)_CHECKSUM := a9761cd9c3da485eb354175fcc2fe35856bc43ac
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
    $(SED) -i 's,^ *case SIGQUIT:.*,,' '$(1)/signals.c'
    $(SED) -i 's,^ *case SIGTSTP:.*,,' '$(1)/signals.c'
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-multibyte \
        --without-purify \
        --with-curses \
        LIBS='-lcurses'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(if $(BUILD_STATIC),SHARED_LIBS=,SHLIB_LIBS='-lcurses')
endef
