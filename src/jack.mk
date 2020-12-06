# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := jack
$(PKG)_WEBSITE  := https://jackaudio.org/
$(PKG)_DESCR    := JACK Audio Connection Kit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9.16
$(PKG)_CHECKSUM := e176d04de94dcaa3f9d32ca1825091e1b938783a78c84e7466abd06af7637d37
$(PKG)_GH_CONF  := jackaudio/jack2/tags,v
$(PKG)_DEPS     := cc libgnurx libsamplerate libsndfile portaudio pthreads readline

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
            --platform=win32 \
            LDFLAGS=-lreadline
endef

$(PKG)_BUILD_STATIC =
