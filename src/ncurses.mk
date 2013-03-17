# This file is part of MXE.
# See index.html for further information.

# ncurses
PKG             := ncurses
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 3e042e5f2c7223bffdaac9646a533b8c758b65b5
$(PKG)_SUBDIR   := ncurses-$($(PKG)_VERSION)
$(PKG)_FILE     := ncurses-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnu.org/pub/gnu/ncurses/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/pub/gnu/ncurses/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="ncurses-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # native build of terminfo compiler
    cp -Rp '$(1)' '$(1).native'
    cd '$(1).native' && ./configure
    $(MAKE) -C '$(1).native/include' -j '$(JOBS)'
    $(MAKE) -C '$(1).native/progs'   -j '$(JOBS)' tic

    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix=$(PREFIX)/$(TARGET) \
        --disable-home-terminfo \
        --enable-sp-funcs \
        --enable-term-driver \
        --enable-interop \
        --without-debug \
        --without-ada \
        --without-manpages \
        --enable-pc-files \
        --with-normal \
        --without-shared
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install TIC_PATH='$(1).native/progs/tic'
endef
