# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := jack
$(PKG)_WEBSITE  := https://jackaudio.org/
$(PKG)_DESCR    := JACK Audio Connection Kit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2504203
$(PKG)_CHECKSUM := ae50c3290f92485b378ebd249f1f9dbb4386781434d034519aa127e5a076754e
$(PKG)_GH_CONF  := jackaudio/jack2/branches/develop
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
