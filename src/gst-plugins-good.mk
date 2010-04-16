# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# gst-plugins-good
PKG             := gst-plugins-good
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.10.21
$(PKG)_CHECKSUM := ed619824f5ca4592bfe2b2f6df9d53f08bf5f360
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://gstreamer.freedesktop.org/
$(PKG)_URL      := http://gstreamer.freedesktop.org/src/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib libxml2 gstreamer gst-plugins-base liboil libshout cairo flac gtk jpeg libpng speex taglib

define $(PKG)_UPDATE
    wget -q -O- 'http://cgit.freedesktop.org/gstreamer/gst-plugins-good/refs/tags' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=[^0-9]*\\([0-9][^']*\\)'.*,\\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && aclocal -I m4 -I common/m4
    cd '$(1)' && automake
    cd '$(1)' && autoconf
    find '$(1)' -name Makefile.in \
        -exec $(SED) -i 's,glib-mkenums,$(PREFIX)/$(TARGET)/bin/glib-mkenums,g'       {} \; \
        -exec $(SED) -i 's,glib-genmarshal,$(PREFIX)/$(TARGET)/bin/glib-genmarshal,g' {} \;
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-debug \
        --disable-check \
        --disable-tests \
        --disable-examples \
        --mandir='$(1)/sink' \
        --docdir='$(1)/sink' \
        --with-html-dir='$(1)/sink'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
