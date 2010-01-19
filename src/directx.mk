# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# DirectX
PKG             := directx
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.0
$(PKG)_CHECKSUM := dd214d0ab1c202fa2c458850861c07926f929b8b
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := dx$(subst .,,$($(PKG)_VERSION))_mgw.zip
$(PKG)_WEBSITE  := http://msdn.microsoft.com/directx/
$(PKG)_URL      := http://alleg.sourceforge.net/files/$($(PKG)_FILE)
$(PKG)_DEPS     := w32api

define $(PKG)_UPDATE
    wget -q -O- 'http://alleg.sourceforge.net/wip.html' | \
    $(SED) -n 's,.*dx\([0-9]\)\([^>]*\)_mgw\.zip.*,\1.\2,p' | \
    tail -1
endef

define $(PKG)_BUILD
    $(INSTALL) -d                         '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/include/'*.h   '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/include/'*.inl '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -d                         '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/lib/'*.a       '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/include/'*.inl '$(PREFIX)/$(TARGET)/include/'
endef
