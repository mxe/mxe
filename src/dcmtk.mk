# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := dcmtk
$(PKG)_WEBSITE  := https://dicom.offis.de/dcmtk.php.en
$(PKG)_DESCR    := DCMTK
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.7.0
$(PKG)_CHECKSUM := f103df876040a4f904f01d2464f7868b4feb659d8cd3f46a5f1f61aa440be415
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://dicom.offis.de/download/$(PKG)/$(PKG)$(subst .,,$($(PKG)_VERSION))/$($(PKG)_FILE)
$(PKG)_URL_2    := https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/d/$(PKG)/$(PKG)_$($(PKG)_VERSION).orig.tar.gz
$(PKG)_DEPS     := cc libpng libxml2 openssl tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://dicom.offis.de/dcmtk.php.en' | \
    $(SED) -n 's,.*/dcmtk-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

# openssl 1.1 breaks build and newer version switched to cmake with
# build that requires wine - disable openssl for now
# see plugins/examples/openssl1.0 for example of re-enabling support
define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DDCMTK_WITH_OPENSSL=OFF \
        -DDCMTK_WITH_PNG=ON \
        -DDCMTK_WITH_TIFF=ON \
        -DDCMTK_WITH_XML=ON \
        -DDCMTK_WITH_ZLIB=ON \
        -DBUILD_APPS=OFF \
        -DHAVE_SYS_MMAN_H=0
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    (echo '#include <dcmtk/config/osconfig.h>'; \
     echo '#include <dcmtk/dcmdata/dctk.h>'; \
     echo 'int main() { DcmItem *item = new DcmItem(); delete item; return 0; }') > '$(BUILD_DIR)/test-$(PKG).cc'
    '$(TARGET)-g++' \
        -W -Wall -Werror -pedantic \
        '$(BUILD_DIR)/test-$(PKG).cc' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef


