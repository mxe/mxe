# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ncurses
$(PKG)_WEBSITE  := https://www.gnu.org/software/ncurses/
$(PKG)_DESCR    := Ncurses
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := e14300b
$(PKG)_CHECKSUM := 3564ffa540cc069854607a0fb10d258c12769f8f6ee752f66038ba95a5e5f650
# $(PKG)_VERSION  := 5.9
# $(PKG)_SUBDIR   := ncurses-$($(PKG)_VERSION)
# $(PKG)_FILE     := ncurses-$($(PKG)_VERSION).tar.gz
# $(PKG)_URL      := https://ftp.gnu.org/gnu/ncurses/$($(PKG)_FILE)
$(PKG)_SUBDIR   := mirror-$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/mirror/$(PKG)/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libgnurx

define $(PKG)_UPDATE_RELEASE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/ncurses/?C=M;O=D' | \
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

    cd '$(1)' && \
        TIC_PATH='$(1).native/progs/tic' \
        ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix=$(PREFIX)/$(TARGET) \
        --with-build-cc=$(BUILD_CC) \
        --with-build-cpp='$(BUILD_CC) -E' \
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
        --with-pkg-config-libdir='$(PREFIX)/$(TARGET)/lib/pkgconfig' \
        $(if $(BUILD_STATIC), \
            --with-normal    --without-shared --with-static, \
            --without-normal --without-static --with-shared)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
