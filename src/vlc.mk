# This file is part of MXE.
# See index.html for further information.

# Qwt - Qt widgets for technical applications
PKG             := vlc
$(PKG)_VERSION  := 2.0.6
$(PKG)_CHECKSUM := 6d33a52367f7a82498ba27812bec4e15de005534
#$(PKG)_CHECKSUM := 2ce21c949275702452bb1327febf6e98748a7972
$(PKG)_SUBDIR   := $(PKG)
$(PKG)_FILE     := $(PKG).tar.gz
$(PKG)_WEBSITE  := http://videolan.org
$(PKG)_URL      := ftp://ftp.videolan.org/pub/videolan/vlc/2.0.6/vlc-2.0.6.tar.xz
$(PKG)_DEPS     := gcc qt dbus lua libgcrypt gnutls ffmpeg

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

$(PKG)_BUILD_i686-pc-mingw32 =
$(PKG)_BUILD_i686-w64-mingw32 =
$(PKG)_BUILD_x86_64-w64-mingw32 =
