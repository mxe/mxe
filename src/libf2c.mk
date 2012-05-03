# This file is part of MXE.
# See index.html for further information.

PKG             := libf2c
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := f71066b41695738dec2261de71eaf02a1aaffe8b
$(PKG)_SUBDIR   :=
$(PKG)_FILE     := $(PKG).zip
$(PKG)_URL      := http://www.netlib.org/f2c/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 1
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)' -f makefile.u \
        CC=$(TARGET)-gcc \
        AR=$(TARGET)-ar \
        LD=$(TARGET)-ld \
        RANLIB=$(TARGET)-ranlib \
        CFLAGS='-O -DUSE_CLOCK'
    $(INSTALL) -m644 '$(1)/libf2c.a' '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/f2c.h'    '$(PREFIX)/$(TARGET)/include'
endef
