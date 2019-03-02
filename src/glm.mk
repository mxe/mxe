# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := glm
$(PKG)_WEBSITE  := https://glm.g-truc.net/
$(PKG)_DESCR    := GLM - OpenGL Mathematics
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.9.0
$(PKG)_CHECKSUM := 514dea9ac0099dc389cf293cf1ab3d97aff080abad55bf79d4ab7ff6895ee69c
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
