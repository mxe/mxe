# Copyright (C) 2009  Volker Grabsch
#                     Mark Brand
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject
# to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# LibUsb
PKG             := libusb
$(PKG)_VERSION  := 0.1.12.2
$(PKG)_CHECKSUM := a433ff5cf8dd24f5308491c8500a2143497b4b8f
$(PKG)_SUBDIR   := $(PKG)-win32-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-win32-src-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://libusb-win32.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/libusb-win32/libusb-win32-releases/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/libusb-win32/files/libusb-win32-releases/) | \
    $(SED) -n 's,.*libusb-win32-src-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    # convert DOS line endings
    $(SED) 's,\r$$,,' -i '$(1)/Makefile'

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
    $(INSTALL) -m664 '$(1)/src/usb.h' '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m664 '$(1)/libusb.a'  '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m664 '$(1)/libusbd.a' '$(PREFIX)/$(TARGET)/lib/'
endef
