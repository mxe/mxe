# This file is part of MXE.
# See index.html for further information.

PKG             := libwebsockets
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4-chrome43-firefox-36
$(PKG)_CHECKSUM := f2c4cb05abb3ddac09a61f63cbd018665da2d450
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
