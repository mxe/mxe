# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtsparkle
$(PKG)_WEBSITE  := https://github.com/davidsansome/qtsparkle
$(PKG)_DESCR    := Qt auto-updater lib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4c852e57061d7928573afdf88f04f89d85167477
$(PKG)_CHECKSUM := 6b8500de51c6a8dd402663fed99bced0588e5be50cfe8474f6d3b46f92025934
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/davidsansome/$(PKG)/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc qttools

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, davidsansome/qtsparkle)
endef

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
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `$(TARGET)-pkg-config qtsparkle@qtsparkle_version_suffix@ --cflags --libs`
endef

$(PKG)_BUILD = $(subst @qtsparkle_use_qt4@,OFF, \
               $(subst @qtsparkle_version_suffix@,-qt5, \
               $(subst @qtsparkle_pc_requires@,Qt5Core Qt5Network Qt5Widgets, \
               $($(PKG)_BUILD_COMMON))))
