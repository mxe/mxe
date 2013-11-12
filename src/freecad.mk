# This file is part of MXE.
# See index.html for further information.

PKG             := freecad
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 0.13.1830
$(PKG)_CHECKSUM := 82d58b91a28a4cd5d138666d2ed0f36bf18c0255
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://downloads.sourceforge.net/project/free-cad/FreeCAD%20Source/freecad-0.13.1830.tar.gz
https://github.com/$(PKG)/$(PKG)/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc boost eigen freetype python qt

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/free-cad/?source=dlp' | \
    $(SED) 's,.*freecad-\([0-9\.]\).tar.gz .*,\1,g;' | \
    head -1
endef

define $(PKG)_BUILD

    cd '$(1)' && $(PREFIX)/$(TARGET)/qt5/bin/qmake 

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    
    $(MAKE) -C '$(1)' -j 1 install
    
endef
