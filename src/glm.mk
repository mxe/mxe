# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := glm
$(PKG)_WEBSITE  := https://glm.g-truc.net/
$(PKG)_DESCR    := GLM - OpenGL Mathematics
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.7.6
$(PKG)_CHECKSUM := 872fdea580b69b752562adc60734d7472fd97d5724c4ead585564083deac3953
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
