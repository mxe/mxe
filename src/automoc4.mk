# This file is part of MXE.
# See index.html for further information.

# Qwt - Qt widgets for technical applications
PKG             := automoc4
$(PKG)_VERSION  := 0.9.88
$(PKG)_CHECKSUM := 234116f4c05ae21d828594d652b4c4a052ef75727e2d8a4f3a4fb605de9e4c49
#d864c3dda99d8b5f625b9267acfa1d88ff617e3a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.kde.org/
$(PKG)_URL      := http://download.kde.org/stable/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qt

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://download.kde.org/stable/automoc4/' | \
    $(SED) -n 's,.*a href="\([0-9.]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
	mkdir '$(1)'/build

	cd '$(1)'/build && cmake \
		-DCMAKE_INSTALL_PREFIX=$(PREFIX)/$(TARGET)/qt/ \
        	-DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
		..

	$(MAKE) -C '$(1)/build' -j $(JOBS) VERBOSE=1
#	$(MAKE) -C '$(1)/build' -j $(JOBS) install

endef

$(PKG)_BUILD_i686-pc-mingw32 =
$(PKG)_BUILD_i686-w64-mingw32 =
$(PKG)_BUILD_x86_64-w64-mingw32 =

