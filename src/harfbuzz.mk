# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := harfbuzz
$(PKG)_WEBSITE  := https://wiki.freedesktop.org/www/Software/HarfBuzz/
$(PKG)_DESCR    := HarfBuzz
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.7.1
$(PKG)_CHECKSUM := 431c856ff18eeca89b2a36b58f2c2d56273cd522c34c0ffbc9dd6f7da4b9bd08
$(PKG)_GH_CONF  := harfbuzz/harfbuzz/releases
$(PKG)_DEPS     := cc cairo freetype-bootstrap glib icu4c

define $(PKG)_BUILD
    # mman-win32 is only a partial implementation
    cd '$(1)' && ./autogen.sh && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        ac_cv_header_sys_mman_h=no \
        CXXFLAGS='-std=c++11' \
        LIBS='-lstdc++'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
