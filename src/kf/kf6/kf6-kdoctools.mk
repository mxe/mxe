# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-kdoctools
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 3fbea5de215076130007f3c18e16b870774ffa4fc85ddace201ac020d0245fb6
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase kf6-karchive kf6-ki18n gettext libxml2 libxslt docbook-xml docbook-xsl $(BUILD)~$(PKG)
$(PKG)_DEPS_$(BUILD) := $(BUILD)~kf6-extra-cmake-modules $(BUILD)~qt6-qtbase $(BUILD)~kf6-karchive $(BUILD)~kf6-ki18n $(BUILD)~gettext $(BUILD)~libxml2 $(BUILD)~libxslt $(BUILD)~docbook-xml $(BUILD)~docbook-xsl
$(PKG)_TARGETS   := $(BUILD) $(MXE_TARGETS)
$(PKG)_IGNORE    := 

define $(PKG)_BUILD_$(BUILD)
    sed -i 's/NO_DEFAULT_PATH/NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH/g' '$(SOURCE_DIR)/KF6DocToolsConfig.cmake.in'
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DDocBookXML4_DTD_DIR='$(PREFIX)/$(TARGET)/share/xml/docbook/schema/dtd/4.5' \
        -DDocBookXSL_DIR='$(PREFIX)/$(TARGET)/share/xml/docbook/xsl-stylesheets' \
        -DINSTALL_INTERNAL_TOOLS=ON
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef

define $(PKG)_BUILD
    sed -i 's/NO_DEFAULT_PATH/NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH/g' '$(SOURCE_DIR)/KF6DocToolsConfig.cmake.in'
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DDocBookXML4_DTD_DIR='$(PREFIX)/$(TARGET)/share/xml/docbook/schema/dtd/4.5' \
        -DDocBookXSL_DIR='$(PREFIX)/$(TARGET)/share/xml/docbook/xsl-stylesheets' \
        -DMEINPROC6_EXECUTABLE='$(PREFIX)/$(BUILD)/qt6/bin/meinproc6' \
        -DDOCBOOKL10NHELPER_EXECUTABLE='$(PREFIX)/$(BUILD)/qt6/bin/docbookl10nhelper'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
