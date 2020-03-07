# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libidn2
$(PKG)_WEBSITE  := https://www.gnu.org/software/libidn/\#libidn2
$(PKG)_DESCR    := implementation of IDNA2008/TR46 internationalized domain names
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.0
$(PKG)_CHECKSUM := 6b222435016e2d9fce34af0b21057ebc85704c27e41a781466d9287f0627dc93
$(PKG)_SUBDIR   := libidn2-$($(PKG)_VERSION)
$(PKG)_FILE     := libidn2-$($(PKG)_VERSION).tar.lz
$(PKG)_URL      := https://ftp.gnu.org/gnu/libidn/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libiconv libunistring

define $(PKG)_UPDATE
    $(WGET) -q -O- https://gitlab.com/libidn/libidn2/tags | \
    $(SED) -n 's,.*libidn2-\([0-9][^t]*\).tar.gz.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)

    # create pkg-config files
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: implementation of IDNA2008/TR46 internationalized domain names'; \
     echo 'Libs: -lidn2'; \
     echo 'Libs.private: -lunistring -liconv -lcharset';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'
    # TODO create pc files for iconv and unistring.

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
