# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := quick-der
$(PKG)_WEBSITE  := github.com
$(PKG)_DESCR    := quick-der
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1becc1d
$(PKG)_CHECKSUM := 1c64b95555c6a9353793a22643a319330a4e3a55f4192efcdc07eaf648db274d
$(PKG)_GH_CONF  := vanrein/quick-der/master
$(PKG)_DEPS     := gcc
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

$(PKG)_DEPS_$(BUILD) := arpa2cm python-conf py-asn1ate py-six

define $(PKG)_BUILD_$(BUILD)
    # install python lib
    cd '$(SOURCE_DIR)' && python setup.py install \
        --prefix='$(PREFIX)/$(TARGET)'
endef

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DDEBUG=OFF \
        -DNO_INSTALL_PYTHON=ON \
        -DNO_TESTING=ON
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'

    '$(TARGET)-cmake' \
        -DCMAKE_INSTALL_COMPONENT=$(if $(BUILD_STATIC),quickderStatic,quickderShared) \
        -P '$(BUILD_DIR)/cmake_install.cmake'
    '$(TARGET)-cmake' \
        -DCMAKE_INSTALL_COMPONENT=dev \
        -P '$(BUILD_DIR)/cmake_install.cmake'

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall \
        '$(SOURCE_DIR)/test/der_data.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' Quick-DER --cflags --libs`
endef
