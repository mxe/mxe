# This file is part of MXE.
# See index.html for further information.

PKG             := portablexdr
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.9.1
$(PKG)_CHECKSUM := 5cf4bdd153cf4d44eaf10b725f451d0cfadc070b4b9a9ccfb64094b8f78de72c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://people.redhat.com/~rjones/portablexdr/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- "http://people.redhat.com/~rjones/portablexdr/files/?C=M;O=D" | \
    grep -i '<a href=.*tar' | \
    $(SED) -n 's,.*portablexdr-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        AR='$(TARGET)-ar'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
