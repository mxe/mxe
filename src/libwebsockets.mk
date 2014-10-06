# This file is part of MXE.
# See index.html for further information.

PKG             := libwebsockets
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3-chrome37-firefox30
$(PKG)_CHECKSUM := ee1005165346d2217db4a9c40c4711f741213557
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://git.libwebsockets.org/cgi-bin/cgit/libwebsockets/snapshot/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc openssl zlib

define $(PKG)_UPDATE
    echo 'TODO: write update script for libwebsockets.' >&2;
    echo $(libwebsockets_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake \
        -DLWS_WITHOUT_TESTAPPS=ON \
        -DLWS_USE_EXTERNAL_ZLIB=ON \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'
    $(MAKE) -C '$(1)' -j $(JOBS)
    $(MAKE) -C '$(1)' install
endef

# MinGW 32 lacks mstcpip.h
$(PKG)_BUILD_i686-pc-mingw32 =