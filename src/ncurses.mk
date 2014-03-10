# This file is part of MXE.
# See index.html for further information.

PKG             := ncurses
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.9
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
        --with-build-cc=gcc \
        --with-build-cpp=cpp \
        --disable-home-terminfo \
        --enable-sp-funcs \
        --enable-term-driver \
        --enable-interop \
        --without-debug \
        --without-ada \
        --without-manpages \
        --without-progs \
        --without-tests \
        --enable-pc-files \
        PKG_CONFIG_LIBDIR='$(PREFIX)/$(TARGET)/lib/pkgconfig' \
        --with-normal \
        --without-shared
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install TIC_PATH='$(1).native/progs/tic'
endef

$(PKG)_BUILD_SHARED =
