# This file is part of MXE.
# See index.html for further information.

PKG             := jack
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9.10
$(PKG)_CHECKSUM := 5bc6336e6ac9799e3cb241915e2ba5d01b030589bbb2afae39579a59ef0f2f56
$(PKG)_SUBDIR   := jack-$($(PKG)_VERSION)
$(PKG)_FILE     := jack-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://dl.dropboxusercontent.com/u/28869550/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libgnurx libsamplerate libsndfile portaudio readline winpthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://jackaudio.org/downloads/' | \
    $(SED) -n 's,.*jack-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' &&                                  \
        AR='$(TARGET)-ar'                         \
        CC='$(TARGET)-gcc'                        \
        CXX='$(TARGET)-g++'                       \
        PKGCONFIG='$(TARGET)-pkg-config'          \
        ./waf configure build install             \
            -j '$(JOBS)'                          \
            --prefix='$(PREFIX)/$(TARGET)'        \
            --dist-target=mingw
endef
