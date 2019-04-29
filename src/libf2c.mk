# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libf2c
$(PKG)_WEBSITE  := https://www.netlib.org/f2c/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1
$(PKG)_CHECKSUM := ca404070e9ce0a9aaa6a71fc7d5489d014ade952c5d6de7efb88de8e24f2e8e0
$(PKG)_SUBDIR   :=
$(PKG)_FILE     := $(PKG).zip
$(PKG)_URL      := https://www.netlib.org/f2c/$($(PKG)_FILE)
# $(PKG)_URL_2 was disabled in https://github.com/mxe/mxe/issues/1719
# because it has old version of the file.
# $(PKG)_URL_2    := https://netlib.sandia.gov/f2c/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    echo 1
endef

$(PKG)_MAKE_OPTS = \
        -f makefile.u \
        CC=$(TARGET)-gcc \
        AR=$(TARGET)-ar \
        LD=$(TARGET)-ld \
        RANLIB=$(TARGET)-ranlib \
        CFLAGS='-O -DUSE_CLOCK'

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)' $($(PKG)_MAKE_OPTS) || $(MAKE) -C '$(1)' -j 1 $($(PKG)_MAKE_OPTS)

    $(INSTALL) -m644 '$(1)/libf2c.a' '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/f2c.h'    '$(PREFIX)/$(TARGET)/include'
endef

$(PKG)_BUILD_SHARED =
