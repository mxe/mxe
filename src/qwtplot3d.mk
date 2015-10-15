# This file is part of MXE.
# See index.html for further information.

PKG             := qwtplot3d
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.2.7
$(PKG)_CHECKSUM := 1208336b15e82e7a9d22cbc743e46f27e2fad716094a9c133138f259fa299a42
$(PKG)_SUBDIR   := $(PKG)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qt zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/$(PKG)/files/$(PKG)/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/lib/libqwtplot3d.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/qwtplot3d'
    $(INSTALL) -m644 '$(1)/include'/*.h  '$(PREFIX)/$(TARGET)/include/qwtplot3d/'
endef

$(PKG)_BUILD_SHARED =
