# This file is part of MXE.
# See index.html for further information.

PKG             := grantlee
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.1.0
$(PKG)_CHECKSUM := 3836572fe5e49d28a1d99186c6d96f88ff839644b4bc77b73b6d8208f6ccc9d1
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/steveire/$(PKG)/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc qtbase pcre qtscript
define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, steveire/grantlee)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && '$(TARGET)-cmake' '$(1)' \
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install

#    $(TARGET)-g++ \
#        -W -Wall -Werror -ansi -pedantic \
#        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
#        `$(TARGET)-pkg-config $(PKG) --cflags --libs`
endef
