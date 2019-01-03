# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libieee1284
$(PKG)_WEBSITE  := http://cyberelk.net/tim/software/libieee1284/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.2.11
$(PKG)_CHECKSUM := 7730de107782e5d2b071bdcb5b06a44da74856f00ef4a9be85d1ba4806a38f1a
$(PKG)_SUBDIR   := libieee1284-$($(PKG)_VERSION)
$(PKG)_FILE     := libieee1284-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O - https://sourceforge.net/projects/libieee1284/files/ | \
    tr '\n' ' ' | \
    $(SED) 's/.*Looking for the latest version//;s/\(libieee1284-[0-9.]\+\)\.[^0-9].*/\1/;s/.*-//'
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --without-python
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_DOCS)
endef
