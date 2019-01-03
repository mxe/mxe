# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libpaper
$(PKG)_WEBSITE  := https://packages.debian.org/unstable/libpaper1
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.24+nmu5
$(PKG)_CHECKSUM := e29deda4cd7350189c71af0925cbf4a4473f9841d1419a922e1e8ff1954db1f2
$(PKG)_SUBDIR   := libpaper-$($(PKG)_VERSION)
$(PKG)_FILE     := libpaper_$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://deb.debian.org/debian/pool/main/libp/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/libp/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://packages.debian.org/unstable/source/libpaper' | \
    $(SED) -n 's,.*libpaper_\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: libpaper'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: library for handling paper characteristics'; \
     echo 'Libs: -lpaper';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/libpaper.pc'
endef

