# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pe-util
$(PKG)_WEBSITE  := https://github.com/gsauthof/pe-util
$(PKG)_DESCR    := List shared object dependencies of a portable executable (PE)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2af684a
$(PKG)_CHECKSUM := 9bb507941c14a8f6e55ff5e8ebec95db5bbebc9139e69f9f54db324bbad0d39d
$(PKG)_GH_CONF  := gsauthof/pe-util/branches/master
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := $(BUILD)~$(PKG)
$(PKG)_DEPS_$(BUILD) := boost cmake pe-parse

define $(PKG)_PRE_CONFIGURE
    # expects pe-parse in source tree as git submodule
    $(call PREPARE_PKG_SOURCE,pe-parse,$(BUILD_DIR))
    rm -rf '$(SOURCE_DIR)/pe-parse'
    mv '$(BUILD_DIR)/$(pe-parse_SUBDIR)' '$(SOURCE_DIR)/pe-parse'
endef

define $(PKG)_BUILD
    # install prefixed wrapper with default paths
    $(if $(BUILD_SHARED),
        (echo '#!/bin/sh'; \
         echo 'exec "$(PREFIX)/$(BUILD)/bin/peldd" \
                    --clear-path \
                    --path "$(PREFIX)/$(TARGET)/bin" \
                    --path "$(PREFIX)/$(TARGET)/qt5/bin" \
                    --wlist uxtheme.dll \
                    --wlist opengl32.dll \
                    --wlist userenv.dll \
                    "$$@"') \
                 > '$(PREFIX)/bin/$(TARGET)-peldd'
        chmod 0755 '$(PREFIX)/bin/$(TARGET)-peldd'
    )
endef

define $(PKG)_BUILD_$(BUILD)
    $($(PKG)_PRE_CONFIGURE)
    # build and install the binary
    cd '$(BUILD_DIR)' && cmake '$(SOURCE_DIR)' \
        -DCMAKE_INSTALL_PREFIX='$(PREFIX)/$(TARGET)' \
        -DBOOST_ROOT='$(PREFIX)/$(TARGET)' \
        -DBOOST_INCLUDEDIR='$(PREFIX)/$(TARGET)/include' \
        -DBOOST_LIBRARYDIR='$(PREFIX)/$(TARGET)/lib' \
        -DBoost_NO_SYSTEM_PATHS=ON \
        -DBoost_NO_BOOST_CMAKE=ON \
        -DCMAKE_CXX_FLAGS='-I$(PREFIX)/$(TARGET)/include'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
