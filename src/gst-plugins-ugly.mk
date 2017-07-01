#This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gst-plugins-ugly
$(PKG)_WEBSITE  := https://gstreamer.freedesktop.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6.2
$(PKG)_CHECKSUM := e7f1b6321c8667fabc0dedce3998a3c6e90ce9ce9dea7186d33dc4359f9e9845
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://gstreamer.freedesktop.org/src/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc a52dec gst-plugins-base gstreamer lame libcdio libdvdread \
                   libmad opencore-amr twolame x264

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

    # some .dlls are installed to lib - no obvious way to change
    $(if $(BUILD_SHARED),
        mv -vf '$(PREFIX)/$(TARGET)/lib/gstreamer-1.0/'*.dll '$(PREFIX)/$(TARGET)/bin/'
    )
endef
