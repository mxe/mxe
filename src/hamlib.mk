# This file is part of MXE. See LICENSE.md for licensing information.
# visit https://hamlib.github.io/ or https://github.com/N0NB/hamlib
# 2016-12-24 Lars Holger Engelhard DL5RCW

PKG             := hamlib
$(PKG)_WEBSITE  := https://hamlib.github.io/
$(PKG)_DESCR    := HamLib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.3
$(PKG)_CHECKSUM := c90b53949c767f049733b442cd6e0a48648b55d99d4df5ef3f852d985f45e880
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
