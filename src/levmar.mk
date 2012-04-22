# This file is part of MXE.
# See index.html for further information.

PKG             := levmar
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://www.ics.forth.gr/~lourakis/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc lapack 

define $(PKG)_UPDATE
    wget -q -O- 'http://www.netlib.org/lapack/' | \
    $(SED) -n 'Latest:.*levmar-\([0-9]\.[0-9]\).*_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_AR='$(PREFIX)/bin/$(TARGET)-ar' \
        .
    $(MAKE) -C '$(1)/SRC' -j '$(JOBS)' install
endef
