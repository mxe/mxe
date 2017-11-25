# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pkgconf-host
$(PKG)_IGNORE    = $(pkgconf_IGNORE)
$(PKG)_VERSION   = $(pkgconf_VERSION)
$(PKG)_CHECKSUM  = $(pkgconf_CHECKSUM)
$(PKG)_SUBDIR    = $(pkgconf_SUBDIR)
$(PKG)_FILE      = $(pkgconf_FILE)
$(PKG)_URL       = $(pkgconf_URL)
$(PKG)_URL_2     = $(pkgconf_URL_2)
$(PKG)_DEPS     := cc libffi

define $(PKG)_UPDATE
    echo $(pkgconf_VERSION)
endef

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && ./autogen.sh
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # create pkg-config script with relative paths
    (echo '#!/bin/sh'; \
     echo 'PKG_CONFIG_PATH="../qt5/lib/pkgconfig":"$$PKG_CONFIG_PATH_$(subst .,_,$(subst -,_,$(TARGET)))" \
           PKG_CONFIG_LIBDIR='\''../lib/pkgconfig'\'' \
           exec '../bin/pkgconf' \
               $(if $(BUILD_STATIC),--static) \
               --define-variable=prefix=.. \
               "$$@"' \
    )         > '$(PREFIX)/$(TARGET)/bin/pkg-config'
    chmod 0755 '$(PREFIX)/$(TARGET)/bin/pkg-config'

    # test compilation on host with libffi in non-std prefix
    cp '$(PWD)/src/libffi-test.c' '$(PREFIX)/$(TARGET)/bin/test-$(PKG).c'
    (echo '#!/bin/sh'; \
     echo 'export PATH=../bin:$PATH'; \
     echo 'gcc -v \
               -W -Wall -Werror -ansi -pedantic \
               test-$(PKG).c -o test-$(PKG).exe \
               `pkg-config --cflags --libs libffi`'; \
     echo 'test-$(PKG).exe'; \
    )        > '$(PREFIX)/$(TARGET)/bin/test-$(PKG)'
    chmod 0755 '$(PREFIX)/$(TARGET)/bin/test-$(PKG)'
endef
