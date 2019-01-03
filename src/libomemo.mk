# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libomemo
$(PKG)_WEBSITE  := https://github.com/gkdr/libomemo
$(PKG)_DESCR    := Implementation of OMEMO in C
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.6.1
$(PKG)_CHECKSUM := 26e2ef3df93d9461ed6d62bbb495b8ac6de385ec7a5aa28ff28dd869ba908170
$(PKG)_GH_CONF  := gkdr/libomemo/tags, v
$(PKG)_DEPS     := cc glib libgcrypt mxml sqlite

define $(PKG)_BUILD
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)' all \
        CC='$(TARGET)-gcc' \
        LD='$(TARGET)-ld' \
        AR='$(TARGET)-ar' \
        PKG_CONFIG='$(TARGET)-pkg-config' \
        LIBGCRYPT_CONFIG='$(PREFIX)/$(TARGET)/bin/libgcrypt-config'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(SOURCE_DIR)/src'/libomemo*.h  '$(PREFIX)/$(TARGET)/include/'
    $(if $(BUILD_STATIC),\
        $(INSTALL) -m644 '$(SOURCE_DIR)/build'/libomemo*.a  '$(PREFIX)/$(TARGET)/lib/' \
    $(else), \
        $(MAKE_SHARED_FROM_STATIC) '$(SOURCE_DIR)/build/libomemo-conversations.a' \
        `$(TARGET)-pkg-config --libs-only-l glib-2.0 sqlite3 mxml libgcrypt`)

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $($(PKG)_DESCR)'; \
     echo 'Requires: glib-2.0 sqlite3 mxml libgcrypt'; \
     echo 'Libs: -lomemo-conversations';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    # test cmake
    mkdir '$(SOURCE_DIR).test-cmake'
    cd '$(SOURCE_DIR).test-cmake' && '$(TARGET)-cmake' \
        -DPKG=$(PKG) \
        '$(PWD)/src/cmake/test'
    $(MAKE) -C '$(SOURCE_DIR).test-cmake' -j 1 install
endef
