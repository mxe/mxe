# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := glm
$(PKG)_WEBSITE  := https://glm.g-truc.net/
$(PKG)_DESCR    := GLM - OpenGL Mathematics
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.7.6
$(PKG)_CHECKSUM := 872fdea580b69b752562adc60734d7472fd97d5724c4ead585564083deac3953
$(PKG)_SUBDIR   := glm-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/g-truc/glm/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, g-truc/glm)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'

    cd '$(1).build' && $(TARGET)-cmake '$(1)'

    $(MAKE) -C '$(1).build' -j '$(JOBS)' install

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-glm.exe'
endef

