# This file is part of MXE.
# See index.html for further information.

PKG             := jack
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9.10
$(PKG)_CHECKSUM := 1177655ae0fbbd8c2229b398a79724115a392941
$(PKG)_SUBDIR   := jack-$($(PKG)_VERSION)
$(PKG)_FILE     := jack-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://dl.dropboxusercontent.com/u/28869550/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libsamplerate libgnurx portaudio libsndfile winpthreads

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
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
