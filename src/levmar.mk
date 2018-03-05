# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := levmar
$(PKG)_WEBSITE  := https://www.ics.forth.gr/~lourakis/levmar
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.6
$(PKG)_CHECKSUM := 3bf4ef1ea4475ded5315e8d8fc992a725f2e7940a74ca3b0f9029d9e6e94bad7
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tgz
$(PKG)_URL      := https://www.ics.forth.gr/~lourakis/$(PKG)/$($(PKG)_FILE)
$(PKG)_UA       := MXE
$(PKG)_DEPS     := cc openblas

define $(PKG)_UPDATE
    $(WGET) -q -O- "https://www.ics.forth.gr/~lourakis/levmar/"  | \
    $(SED) -n 's_.*Latest:.*levmar-\([0-9]\.[0-9]\).*_\1_ip' | \
    head -1;
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)' liblevmar.a \
        CC=$(TARGET)-gcc \
        AR=$(TARGET)-ar \
        RANLIB=$(TARGET)-ranlib \
        LAPACKLIBS="`'$(TARGET)-pkg-config' --libs openblas`"
    $(INSTALL) -m644 '$(SOURCE_DIR)/levmar.h'    '$(PREFIX)/$(TARGET)/include/'
    $(if $(BUILD_STATIC),\
        $(INSTALL) -m644 '$(SOURCE_DIR)/liblevmar.a'  '$(PREFIX)/$(TARGET)/lib/' \
    $(else), \
        $(MAKE_SHARED_FROM_STATIC) '$(SOURCE_DIR)/liblevmar.a' \
        `$(TARGET)-pkg-config --libs openblas`)

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $($(PKG)_DESCR)'; \
     echo 'Requires: openblas'; \
     echo 'Libs: -llevmar'; \
    ) > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall \
        '$(SOURCE_DIR)/expfit.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs` \
        -Dsrandom=srand -Drandom=rand
endef
