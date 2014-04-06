# This file is part of MXE.
# See index.html for further information.

PKG             := libftdi1
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0
$(PKG)_CHECKSUM := 5be76cfd7cd36c5291054638f7caf4137303386f
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.intra2net.com/en/developer/libftdi/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libusb1

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.intra2net.com/en/developer/libftdi/download.php' | \
    $(SED) -n 's,.*libftdi1-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake . \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_BUILD_TYPE=Release \
        -DLIBUSB_INCLUDE_DIR=$(PREFIX)/$(TARGET)/include/libusb-1.0
    $(MAKE) -C '$(1)' -j '$(JOBS)' install VERBOSE=1
endef

$(PKG)_BUILD_SHARED =
