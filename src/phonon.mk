# This file is part of MXE.
# See index.html for further information.

# Qwt - Qt widgets for technical applications
PKG             := phonon
$(PKG)_VERSION  := 4.6.0
$(PKG)_CHECKSUM := d8dbc188b58c6dd9c6a73d3742a25291e647bb95
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.xz
$(PKG)_WEBSITE  := http://www.kde.org/
$(PKG)_URL      := http://download.kde.org/stable/phonon/$($(PKG)_VERSION)/src/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib automoc4

define $(PKG)_UPDATE
#    $(WGET) -q -O- 'http://sourceforge.net/projects/qwt/files/qwt/' | \
#    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
#    head -1
     echo 1
endef

define $(PKG)_BUILD

	mkdir '$(1)/build'
	
	cd '$(1)' && cmake ./cmake -DCMAKE_INSTALL_PREFIX=$(PREFIX)/$(TARGET)/qt \
	      -DPHONON_INSTALL_QT_EXTENSIONS_INTO_SYSTEM_QT=TRUE \
	      -DDBUS_INTERFACES_INSTALL_DIR=$(PREFIX)/$(TARGET)/share/dbus-1/interfaces 

    	$(MAKE) -C '$(1)'  -j '$(JOBS)'
	
    	$(MAKE) -C '$(1)'  -j '$(JOBS)' install

endef

$(PKG)_BUILD_i686-pc-mingw32 =
$(PKG)_BUILD_i686-w64-mingw32 =
$(PKG)_BUILD_x86_64-w64-mingw32 =
