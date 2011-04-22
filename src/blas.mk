# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# blas
PKG             := blas
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1
$(PKG)_CHECKSUM := a643b737c30a0a5b823e11e33c9d46a605122c61
$(PKG)_SUBDIR   := BLAS
$(PKG)_FILE     := $(PKG).tgz
$(PKG)_WEBSITE  := http://www.netlib.org/$(PKG)/
$(PKG)_URL      := http://www.netlib.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.eq.uc.pt/pub/software/math/netlib/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 1
endef

define $(PKG)_BUILD
    $(SED) -i 's,$$(FORTRAN),$(TARGET)-gfortran,g' '$(1)/Makefile'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    cd '$(1)' && $(TARGET)-ar cr libblas.a *.o

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libblas.a' '$(PREFIX)/$(TARGET)/lib/'
endef
