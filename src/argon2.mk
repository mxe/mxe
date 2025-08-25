# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := argon2
$(PKG)_WEBSITE  := https://github.com/P-H-C/phc-winner-argon2
$(PKG)_VERSION  := 20190702
$(PKG)_GH_CONF  := P-H-C/phc-winner-argon2/releases
$(PKG)_CHECKSUM := daf972a89577f8772602bf2eb38b6a3dd3d922bf5724d45e7f9589b5e830442c
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)' \
        CC='$(TARGET)-gcc' \
        AR='$(TARGET)-ar' \
        PREFIX='$(PREFIX)/$(TARGET)'

    $(MAKE) -C '$(1)' -j 1 PREFIX='$(PREFIX)/$(TARGET)' install
    # Move the dll from lib to bin
    $(if $(BUILD_SHARED), mv '$(PREFIX)/$(TARGET)/lib/libargon2.dll' '$(PREFIX)/$(TARGET)/bin/')
    # Remove binary executable meant for host
    rm '$(PREFIX)/$(TARGET)/bin/argon2'
endef
