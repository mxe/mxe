# This file is part of MXE. See LICENSE.md for licensing information.
# visit http://hamlib.org or https://github.com/N0NB/hamlib
# 2016-12-24 Lars Holger Engelhard DL5RCW

PKG             := hamlib
$(PKG)_WEBSITE  := http://www.hamlib.org/
$(PKG)_DESCR    := HamLib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2
$(PKG)_CHECKSUM := b55cb5e6a8e876cceb86590c594ea5a6eb5dff2e30fc13ce053b46baa6d7ad1d
$(PKG)_GH_CONF  := hamlib/hamlib/releases/latest
$(PKG)_DEPS     := cc libusb1 libxml2 pthreads

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        LIBS='-lusb-1.0' \
        --disable-winradio
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' || $(MAKE) -C '$(BUILD_DIR)' -j 1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(PWD)/src/$(PKG)-test.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' --cflags --libs hamlib`
endef
