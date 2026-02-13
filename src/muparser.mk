# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := muparser
$(PKG)_WEBSITE  := https://beltoforion.de/article.php?a=muparser
$(PKG)_DESCR    := muParser
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.5
$(PKG)_CHECKSUM := 20b43cc68c655665db83711906f01b20c51909368973116dfc8d7b3c4ddb5dd4
$(PKG)_GH_CONF  := beltoforion/muparser/tags,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DENABLE_SAMPLES=OFF \
        -DBUILD_SHARED_LIBS:BOOL=$(if $(BUILD_SHARED),ON,OFF)

    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
