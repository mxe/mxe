# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := jack
$(PKG)_WEBSITE  := https://jackaudio.org/
$(PKG)_DESCR    := JACK Audio Connection Kit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9.22
$(PKG)_CHECKSUM := 1e42b9fc4ad7db7befd414d45ab2f8a159c0b30fcd6eee452be662298766a849
$(PKG)_GH_CONF  := jackaudio/jack2/tags,v
$(PKG)_DEPS     := cc libgnurx libsamplerate portaudio pthreads

define $(PKG)_BUILD
    # uses modified waf so can't use MXE waf package
    cd '$(SOURCE_DIR)' && \
        AR='$(TARGET)-ar' \
        CC='$(TARGET)-gcc' \
        CXX='$(TARGET)-g++' \
        PKGCONFIG='$(TARGET)-pkg-config' \
        ./waf configure build install \
            -j '$(JOBS)' \
            --prefix='$(PREFIX)/$(TARGET)' \
            --platform=win32
endef

$(PKG)_BUILD_STATIC =
