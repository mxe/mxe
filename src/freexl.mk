# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := freexl
$(PKG)_WEBSITE  := https://www.gaia-gis.it/fossil/freexl/index
$(PKG)_DESCR    := FreeXL
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.5
$(PKG)_CHECKSUM := 3dc9b150d218b0e280a3d6a41d93c1e45f4d7155829d75f1e5bf3e0b0de6750d
$(PKG)_SUBDIR   := freexl-$($(PKG)_VERSION)
$(PKG)_FILE     := freexl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.gaia-gis.it/gaia-sins/freexl-sources/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.gaia-gis.it/gaia-sins/freexl-sources/' | \
    $(SED) -n 's,.*freexl-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_PROGRAMS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 $(INSTALL_STRIP_LIB)

    # the test program comes from the freexl sources itself (test_xl.c)
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(SOURCE_DIR)/examples/test_xl.c' -o '$(PREFIX)/$(TARGET)/bin/test-freexl.exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`

    # create a batch file to run the test program (as the test program requires arguments)
    (printf 'REM Run the test program against the provided .xls file.\r\n'; \
     printf 'test-freexl.exe test-freexl.xls\r\n';) \
     > '$(PREFIX)/$(TARGET)/bin/test-freexl.bat'

    # copy a test xls file to the target bin directory
    cp -f '$(SOURCE_DIR)/tests/testdata/testcase1.xls' '$(PREFIX)/$(TARGET)/bin/test-freexl.xls'
endef
