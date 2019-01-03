# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libusb
$(PKG)_WEBSITE  := https://libusb-win32.sourceforge.io/
$(PKG)_DESCR    := LibUsb
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.6.0
$(PKG)_CHECKSUM := f3faf094c9b3415ede42eeb5032feda2e71945f13f0ca3da58ca10dcb439bfee
$(PKG)_SUBDIR   := $(PKG)-win32-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-win32-src-$($(PKG)_VERSION).zip
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)-win32/$(PKG)-win32-releases/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

$(PKG)_MESSAGE  :=*** libusb is deprecated - please use libusb1 ***

define $(PKG)_UPDATE
    echo 'Warning: libusb is deprecated' >&2;
    echo $(libusb_VERSION)
endef

define $(PKG)_UPDATE_DISABLED
    $(WGET) -q -O- 'https://sourceforge.net/projects/libusb-win32/files/libusb-win32-releases/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD_DISABLED
    # convert DOS line endings
    $(SED) -i 's,\r$$,,' '$(1)/Makefile'

    # don't actually build the library (DLL file),
    # just create the DLL import stubs
    $(MAKE) -C '$(1)' -j '$(JOBS)' host_prefix=$(TARGET) libusbd.a
    cd '$(1)' && $(TARGET)-dlltool \
        --dllname libusb0.dll \
        --kill-at \
        --add-stdcall-underscore \
        --def libusb0.def \
        --output-lib libusb.a

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/src/lusb0_usb.h' '$(PREFIX)/$(TARGET)/include/usb.h'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libusb.a'  '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libusbd.a' '$(PREFIX)/$(TARGET)/lib/'
endef

$(PKG)_BUILD_SHARED =
