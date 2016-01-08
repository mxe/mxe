# This file is part of MXE.
# See index.html for further information.

PKG             := libftdi1
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2
$(PKG)_CHECKSUM := a6ea795c829219015eb372b03008351cee3fb39f684bff3bf8a4620b558488d6
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
        -DSHAREDLIBS=$(if $(BUILD_SHARED),yes,no) \
        -DSTATICLIBS=$(if $(BUILD_SHARED),no,yes) \
        -DLIBUSB_INCLUDE_DIR=$(PREFIX)/$(TARGET)/include/libusb-1.0 \
        -DDOCUMENTATION=no \
        -DEXAMPLES=no \
        -DFTDIPP=no \
        -DFTDI_EEPROM=no \
        -DPYTHON_BINDINGS=no
    $(MAKE) -C '$(1)' -j '$(JOBS)' install VERBOSE=1

    '$(TARGET)-gcc' \
        -W -Wall -Wextra -Werror \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libftdi1.exe' \
        `'$(TARGET)-pkg-config' libftdi1 --cflags --libs`
endef
