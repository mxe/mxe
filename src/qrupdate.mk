# This file is part of MXE.
# See index.html for further information.

PKG             := qrupdate
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.2
$(PKG)_CHECKSUM := f7403b646ace20f4a2b080b4933a1e9152fac526
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := qrupdate-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://sourceforge.net/projects/qrupdate/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc blas lapack

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package qrupdate.' >&2;
    echo $(qrupdate_VERSION)
endef

define $(PKG)_BUILD
    chmod a+rx '$(1)/configure'
    cd '$(1)' && '$(1)/configure' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-static \
        --disable-shared

    $(MAKE) -C '$(1)' -j '$(JOBS)'

    $(MAKE) -C '$(1)' install
endef
