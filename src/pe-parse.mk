# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pe-parse
$(PKG)_WEBSITE  := https://github.com/trailofbits/pe-parse
$(PKG)_DESCR    := Principled, lightweight C/C++ PE parser
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1c01949
$(PKG)_CHECKSUM := 5dadaf626204dc147d67f724348e8540b5645c3161080b9779ca525a5b2a2189
$(PKG)_GH_CONF  := trailofbits/pe-parse/branches/master
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := cc

# unpack in pe-util for native and cross build
$(PKG)_DEPS_$(BUILD)  :=
$(PKG)_BUILD_$(BUILD) :=

define $(PKG)_BUILD
    # build and install the cross-library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_COMMAND_LINE_TOOLS=OFF \
        -DCMAKE_CXX_FLAGS='-Wno-error=redundant-decls -Wno-error=ignored-qualifiers'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # test cmake find_package() example
    mkdir '$(BUILD_DIR).cmake'
    cd '$(BUILD_DIR).cmake' && $(TARGET)-cmake '$(SOURCE_DIR)/examples/peaddrconv'
    $(MAKE) -C '$(BUILD_DIR).cmake' -j '$(JOBS)'
    $(INSTALL) -m755 '$(BUILD_DIR).cmake/peaddrconv.exe' '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe'
endef
