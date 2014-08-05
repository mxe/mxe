# This file is part of MXE.
# See index.html for further information.

PKG             := libwebsockets
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3-chrome37-firefox30
$(PKG)_CHECKSUM := ee1005165346d2217db4a9c40c4711f741213557
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://git.libwebsockets.org/cgi-bin/cgit/libwebsockets/snapshot/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc openssl

define $(PKG)_UPDATE
    echo 1
endef

define $(PKG)_BUILD
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DLWS_WITHOUT_TESTAPPS=ON \
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install
    
endef

$(PKG)_BUILD_SHARED =