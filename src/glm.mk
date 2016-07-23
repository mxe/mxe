# This file is part of MXE.
# See index.html for further information.

PKG             := glm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.7.4
$(PKG)_CHECKSUM := 0cfa1e40041114cda8ced7e6738860fe6f9a7103d25bcc376adb9840fcf21fe1
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
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-glm.exe'
endef

