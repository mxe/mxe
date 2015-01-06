# This file is part of MXE.
# See index.html for further information.

PKG             := ncurses
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := c6f5464
$(PKG)_CHECKSUM := 5a40e0906139f877be083976f80bf0262dc95ad2
# $(PKG)_VERSION  := 5.9
# $(PKG)_SUBDIR   := ncurses-$($(PKG)_VERSION)
# $(PKG)_FILE     := ncurses-$($(PKG)_VERSION).tar.gz
# $(PKG)_URL      := http://ftp.gnu.org/pub/gnu/ncurses/$($(PKG)_FILE)
$(PKG)_SUBDIR   := mirror-$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/mirror/$(PKG)/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libgnurx

define $(PKG)_UPDATE_RELEASE
    $(WGET) -q -O- 'http://ftp.gnu.org/pub/gnu/ncurses/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="ncurses-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

$(PKG)_UPDATE = $(call MXE_GET_GITHUB_SHA, mirror/ncurses, master)

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
        $(if $(BUILD_STATIC), \
            --with-normal    --without-shared --with-static, \
            --without-normal --without-static --with-shared)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install TIC_PATH='$(1).native/progs/tic'
endef