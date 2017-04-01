# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libomemo
$(PKG)_WEBSITE  := https://github.com/gkdr/libomemo
$(PKG)_DESCR    := Implementation of OMEMO in C
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4.1
$(PKG)_CHECKSUM := af66fd2958dc5d6b23bc488b69e9f431bfb308d79bdd1b1c31de4575862c5142
$(PKG)_GH_CONF  := gkdr/libomemo, v
$(PKG)_DEPS     := gcc glib libgcrypt mxml sqlite

define $(PKG)_BUILD
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)' all \
        CC='$(TARGET)-gcc' \
        LD='$(TARGET)-ld' \
        AR='$(TARGET)-ar' \
        PKG_CONFIG='$(TARGET)-pkg-config' \
        LIBGCRYPT_CONFIG='$(PREFIX)/$(TARGET)/bin/libgcrypt-config'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(SOURCE_DIR)/build'/libomemo*.a  '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(SOURCE_DIR)/src'/libomemo*.h  '$(PREFIX)/$(TARGET)/include/'

    # test cmake
    mkdir '$(SOURCE_DIR).test-cmake'
    cd '$(SOURCE_DIR).test-cmake' && '$(TARGET)-cmake' \
        -DPKG=$(PKG) \
        '$(PWD)/src/cmake/test'
    $(MAKE) -C '$(SOURCE_DIR).test-cmake' -j 1 install
endef

$(PKG)_BUILD_SHARED =
