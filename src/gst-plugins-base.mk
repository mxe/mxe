# This file is part of MXE.
# See index.html for further information.

PKG             := gst-plugins-base
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.5
$(PKG)_CHECKSUM := 77bd8199e7a312d3d71de9b7ddf761a3b78560a2c2a80829d0815ca39cbd551d
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://gstreamer.freedesktop.org/src/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib gstreamer liboil libxml2 ogg pango theora vorbis

$(PKG)_UPDATE = $(subst gstreamer/refs,gst-plugins-base/refs,$(gstreamer_UPDATE))

define $(PKG)_BUILD
    find '$(1)' -name Makefile.in \
        -exec $(SED) -i 's,glib-mkenums,$(PREFIX)/$(TARGET)/bin/glib-mkenums,g'       {} \; \
        -exec $(SED) -i 's,glib-genmarshal,$(PREFIX)/$(TARGET)/bin/glib-genmarshal,g' {} \;
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-debug \
        --disable-examples \
        --disable-x \
        --mandir='$(1)/sink' \
        --docdir='$(1)/sink' \
        --with-html-dir='$(1)/sink'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef

$(PKG)_BUILD_SHARED =
