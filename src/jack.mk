# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := jack
$(PKG)_WEBSITE  := https://jackaudio.org/
$(PKG)_DESCR    := JACK Audio Connection Kit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0d730dd
$(PKG)_CHECKSUM := 34af2b2cdd6666188db575ec6ed52688da735c566b4a770fa922e3845aae82ed
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
