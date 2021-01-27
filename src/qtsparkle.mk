# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtsparkle
$(PKG)_WEBSITE  := https://github.com/davidsansome/qtsparkle
$(PKG)_DESCR    := Qt auto-updater lib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := fde631f
$(PKG)_CHECKSUM := 54d0b386c2a975380afd31e915bb40e9e4fc943139d3d45b44fb2d74c35d8bc5
$(PKG)_GH_CONF  := davidsansome/qtsparkle/branches/master
$(PKG)_DEPS     := cc qttools

define $(PKG)_BUILD_COMMON
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_WITH_QT4=@qtsparkle_use_qt4@
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'prefix=$(PREFIX)/$(TARGET)'; \
     echo 'exec_prefix=$${prefix}'; \
     echo 'libdir=$${exec_prefix}/lib'; \
     echo 'includedir=$${prefix}/include'; \
     echo ''; \
     echo 'Name: $(PKG)'; \
     echo 'Version: '; \
     echo 'Description: Qt auto-updater lib'; \
     echo 'Requires: @qtsparkle_pc_requires@'; \
     echo 'Libs: -L$${libdir} -lqtsparkle@qtsparkle_version_suffix@'; \
     echo 'Cflags: -I$${includedir}') \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/qtsparkle@qtsparkle_version_suffix@.pc'

    $(TARGET)-g++ \
        -W -Wall -Werror -std=c++11 -pedantic \
        -Wno-deprecated-copy \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `$(TARGET)-pkg-config qtsparkle@qtsparkle_version_suffix@ --cflags --libs`
endef

$(PKG)_BUILD = $(subst @qtsparkle_use_qt4@,OFF, \
               $(subst @qtsparkle_version_suffix@,-qt5, \
               $(subst @qtsparkle_pc_requires@,Qt5Core Qt5Network Qt5Widgets, \
               $($(PKG)_BUILD_COMMON))))
