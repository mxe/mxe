# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libidn2
$(PKG)_WEBSITE  := https://www.gnu.org/software/libidn/\#libidn2
$(PKG)_DESCR    := implementation of IDNA2008/TR46 internationalized domain names
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.5
$(PKG)_CHECKSUM := 53f69170886f1fa6fa5b332439c7a77a7d22626a82ef17e2c1224858bb4ca2b8
$(PKG)_SUBDIR   := libidn2-$($(PKG)_VERSION)
$(PKG)_FILE     := libidn2-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/libidn/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libiconv libunistring

define $(PKG)_UPDATE
    $(WGET) -q -O- https://alpha.gnu.org/gnu/libidn/ | \
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
