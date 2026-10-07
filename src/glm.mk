# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := glm
$(PKG)_WEBSITE  := https://glm.g-truc.net/
$(PKG)_DESCR    := GLM - OpenGL Mathematics
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.3
$(PKG)_CHECKSUM := 6775e47231a446fd086d660ecc18bcd076531cfedd912fbd66e576b118607001
$(PKG)_GH_CONF  := g-truc/glm/tags
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake \
        '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-glm.exe'
endef
