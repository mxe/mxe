# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cnats
$(PKG)_WEBSITE  := https://github.com/nats-io/nats.c
$(PKG)_DESCR    := A C client for NATS
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.3.0
$(PKG)_CHECKSUM := 16e700d912034faefb235a955bd920cfe4d449a260d0371b9694d722eb617ae1
$(PKG)_GH_CONF  := nats-io/nats.c/tags,v
$(PKG)_DEPS     := cc openssl

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $($(PKG)_DESCR)'; \
     echo 'Requires:'; \
     echo 'Libs: $(if $(BUILD_STATIC),-lnats_static) -lssl'; \
     echo 'Cflags.private: -std=gnu99';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    # compile test
#    '$(TARGET)-gcc' \
#        -W -Wall -Werror -ansi -pedantic \
#        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
#        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
