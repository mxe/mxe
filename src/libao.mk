# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libao
$(PKG)_WEBSITE  := https://www.xiph.org/libao/
$(PKG)_DESCR    := AO
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.2
$(PKG)_CHECKSUM := df8a6d0e238feeccb26a783e778716fb41a801536fe7b6fce068e313c0e2bf4d
$(PKG)_GH_CONF  := xiph/libao/tags
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && ./autogen.sh
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-pulse=no \
        --disable-esd \
        --enable-wmm \
        LIBS=-lksuser
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall \
        '$(SOURCE_DIR)/doc/ao_example.c' -o \
        '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' ao --cflags --libs`
endef
