# This file is part of MXE.
# See index.html for further information.

PKG             := plibc
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := b545c602dc5b381fcea9d096910dede95168fbeb
$(PKG)_SUBDIR   := PlibC-$($(PKG)_VERSION)
$(PKG)_FILE     := plibc-$($(PKG)_VERSION)-src.tar.gz
$(PKG)_URL      := http://sourceforge.net/projects/plibc/files/plibc/$($(PKG)_VERSION)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := gcc

define $(PKG)_BUILD
    cd '$(1)' && \
    chmod 0755 configure && \
    ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-static \
        --disable-shared
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
