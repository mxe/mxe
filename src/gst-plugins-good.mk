# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# gst-plugins-good
PKG             := gst-plugins-good
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.10.30
$(PKG)_CHECKSUM := 9c78a751bb2f20ad50a1daf6860e0098e0495f5a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://gstreamer.freedesktop.org/
$(PKG)_URL      := http://gstreamer.freedesktop.org/src/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib libxml2 gstreamer gst-plugins-base liboil libshout cairo flac gtk2 jpeg libpng speex taglib

define $(PKG)_UPDATE
    wget -q -O- 'http://cgit.freedesktop.org/gstreamer/gst-plugins-good/refs/tags' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=[^0-9]*\\([0-9][^']*\\)'.*,\\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    find '$(1)' -name Makefile.in \
        -exec $(SED) -i 's,glib-mkenums,$(PREFIX)/$(TARGET)/bin/glib-mkenums,g'       {} \; \
        -exec $(SED) -i 's,glib-genmarshal,$(PREFIX)/$(TARGET)/bin/glib-genmarshal,g' {} \;
    # The value for WAVE_FORMAT_DOLBY_AC3_SPDIF comes from vlc and mplayer:
    #   http://www.videolan.org/developers/vlc/doc/doxygen/html/vlc__codecs_8h-source.html
    #   http://lists.mplayerhq.hu/pipermail/mplayer-cvslog/2004-August/019283.html
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-debug \
        --disable-examples \
        --disable-esd \
        --disable-aalib \
        --disable-x \
        --mandir='$(1)/sink' \
        --docdir='$(1)/sink' \
        --with-html-dir='$(1)/sink'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install CFLAGS='-DWAVE_FORMAT_DOLBY_AC3_SPDIF=0x0092'
endef
