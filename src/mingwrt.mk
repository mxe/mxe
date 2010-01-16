# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# MinGW Runtime
PKG             := mingwrt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.17
$(PKG)_CHECKSUM := c760e6cd1b509545bae1f75a7ba4a34a641a4176
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := mingwrt-$($(PKG)_VERSION)-mingw32-dev.tar.gz
$(PKG)_WEBSITE  := http://mingw.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/mingw/MinGW Runtime/mingwrt-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/mingw/files/MinGW Runtime/) | \
    $(SED) -n 's,.*mingwrt-\([0-9][^>]*\)-mingw32-dev\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    $(INSTALL) -d '$(PREFIX)/$(TARGET)'
    cd '$(1)' && \
        cp -rpv include lib '$(PREFIX)/$(TARGET)'
endef
