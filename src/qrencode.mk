# This file is part of MXE.
# See index.html for further information.

PKG             := qrencode
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4.4
$(PKG)_CHECKSUM := efe5188b1ddbcbf98763b819b146be6a90481aac30cfc8d858ab78a19cde1fa5
$(PKG)_SUBDIR   := qrencode-$($(PKG)_VERSION)
$(PKG)_FILE     := qrencode-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://fukuchi.org/works/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc pthreads libpng

define $(PKG)_UPDATE
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j 1 install
endef
