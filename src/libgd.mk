# This file is part of MXE.
# See index.html for further information.

PKG             := libgd
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.0
$(PKG)_CHECKSUM := 66c56fc07246b66ba649c83e996fd2085ea2f9e2
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://bitbucket.org/libgd/gd-libgd/downloads/$(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_DEPS     := fontconfig freetype libpng jpeg pthreads tiff zlib 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package libgd.' >&2;
    echo $(gd_VERSION)
endef

define $(PKG)_BUILD

    cd '$(1)' && libtoolize && autoreconf -i;

    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
 	PKG_CONFIG_PATH='$(PREFIX)/$(TARGET)/lib/pkgconfig'

    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
