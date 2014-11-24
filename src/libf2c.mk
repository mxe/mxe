# This file is part of MXE.
# See index.html for further information.

PKG             := libf2c
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1
$(PKG)_CHECKSUM := e4a93aeee80c33525ffc87a5f802c30a7e6d1ea4
$(PKG)_SUBDIR   :=
$(PKG)_FILE     := $(PKG).zip
$(PKG)_URL      := http://www.netlib.org/f2c/$($(PKG)_FILE)
$(PKG)_URL_2    := http://netlib.sandia.gov/f2c/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

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
