# This file is part of MXE.
# See index.html for further information.

# Qwt - Qt widgets for technical applications
PKG             := minitube
$(PKG)_CHECKSUM := 6d33a52367f7a82498ba27812bec4e15de005534
$(PKG)_SUBDIR   := $(PKG)
$(PKG)_FILE     := $(PKG).tar.gz
$(PKG)_WEBSITE  := http://flavio.tordini.org/
$(PKG)_URL      := http://flavio.tordini.org/files/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qt phonon-backend-vlc

define $(PKG)_UPDATE
#    $(WGET) -q -O- 'http://sourceforge.net/projects/qwt/files/qwt/' | \
#    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
#    head -1
     echo 1	
endef

define $(PKG)_BUILD

    cd '$(1)' && $(PREFIX)/bin/$(TARGET)-qmake

    $(MAKE) -C '$(1)'  -j '$(JOBS)'

    $(MAKE) -C '$(1)'  -j '$(JOBS)' install

endef
