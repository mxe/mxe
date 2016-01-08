# This file is part of MXE.
# See index.html for further information.

PKG             := geoip-database
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 20150317-1
$(PKG)_CHECKSUM := 45be84939fd22bef1ccaa1189f83c667fef275a16bbfb91f82b7b2068b4e3735
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := $(PKG)_$($(PKG)_VERSION)_all.deb
$(PKG)_URL      := http://http.debian.net/debian/pool/main/g/$(PKG)/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://packages.debian.org/jessie/all/geoip-database/download' | \
    $(SED) -n 's,.*geoip-database_\([0-9\-]*\)_all.deb.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD_$(BUILD)
    mkdir -p '$(PREFIX)/$(BUILD)/share/GeoIP'
    cp '$(1)/usr/share/GeoIP/GeoIP.dat' \
        '$(PREFIX)/$(BUILD)/share/GeoIP/GeoIP.dat'
endef
