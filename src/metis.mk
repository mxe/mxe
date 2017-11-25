# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := metis
$(PKG)_WEBSITE  := glaros.dtc.umn.edu
$(PKG)_DESCR    := metis
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.1.0
$(PKG)_CHECKSUM := 76faebe03f6c963127dbb73c13eab58c9a3faeae48779f049066a21c087c5db2
$(PKG)_SUBDIR   := metis-$($(PKG)_VERSION)
$(PKG)_FILE     := metis-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(call GET_LATEST_VERSION, http://glaros.dtc.umn.edu/gkhome/metis/metis/download, metis-)
endef

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DSHARED=$(CMAKE_SHARED_BOOL)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $($(PKG)_DESCR)'; \
     echo 'Libs: -lmetis'; \
    ) > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    # compile test
    '$(TARGET)-g++' \
        -W -Wall \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
