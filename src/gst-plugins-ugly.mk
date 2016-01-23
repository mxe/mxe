#This file is part of MXE.
# See index.html for further information.

PKG             := gst-plugins-ugly
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6.2
$(PKG)_CHECKSUM := e7f1b6321c8667fabc0dedce3998a3c6e90ce9ce9dea7186d33dc4359f9e9845
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://gstreamer.freedesktop.org/src/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gst-plugins-base gstreamer lame libdvdread x264 a52dec libmad libcdio opencore-amr twolame

$(PKG)_UPDATE = $(subst gstreamer/refs,gst-plugins-ugly/refs,$(gstreamer_UPDATE))

define $(PKG)_BUILD
    find '$(1)' -name Makefile.in \
        -exec $(SED) -i 's,glib-mkenums,$(PREFIX)/$(TARGET)/bin/glib-mkenums,g'       {} \; \
        -exec $(SED) -i 's,glib-genmarshal,$(PREFIX)/$(TARGET)/bin/glib-genmarshal,g' {} \;
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-debug \
        --disable-examples \
        --disable-opengl \
        --mandir='$(1)/sink' \
        --docdir='$(1)/sink' \
        --with-html-dir='$(1)/sink'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
