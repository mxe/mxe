# This file is part of MXE.
# See index.html for further information.

PKG             := thunderbird
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 19.0b1
$(PKG)_CHECKSUM := 7c2cab436f35fcf91978f3e3757edf1f40ec4704
$(PKG)_SUBDIR   := comm-beta
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).source.tar.bz2
$(PKG)_URL      := ftp://ftp.mozilla.org/pub/mozilla.org/thunderbird/releases/19.0b1/source/thunderbird-19.0b1.source.tar.bz2
$(PKG)_DEPS     := gcc python

define $(PKG)_UPDATE
#    wget -q -O- 'http://biosig.sourceforge.net/download.html' | \
#    $(SED) -n 's_.*>libbiosig, version \([0-9]\.[0-9]\.[0-9]\).*tar.gz_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD

	$(SED) -i 's|^ac_add_options --target=.*|ac_add_options --target=$(TARGET)|g' '$(1)'/.mozconfig

  	make -C '$(1)' -f client.mk build

endef

$(PKG)_BUILD_i686-pc-mingw32 =
$(PKG)_BUILD_i686-w64-mingw32 =
$(PKG)_BUILD_x86_64-w64-mingw32 =

