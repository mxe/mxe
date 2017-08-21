# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := glpk
$(PKG)_WEBSITE  := https://www.gnu.org/software/glpk/
$(PKG)_DESCR    := GNU Linear Programming Kit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.60
$(PKG)_CHECKSUM := 1356620cb0a0d33ac3411dd49d9fd40d53ece73eaec8f6b8d19a77887ff5e297
$(PKG)_SUBDIR   := glpk-$($(PKG)_VERSION)
$(PKG)_FILE     := glpk-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/glpk/glpk-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc gmp

# internal zlib is always used
# libmysqlclient and odbc not supported on windows (see INSTALL and configure.ac)

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/glpk/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="glpk-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-gmp
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # create pkg-config files
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: GNU Linear Programming Kit'; \
     echo 'Libs: -lglpk';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(SOURCE_DIR)/examples/netgen.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
