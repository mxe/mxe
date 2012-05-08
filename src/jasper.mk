# This file is part of MXE.
# See index.html for further information.

PKG             := jasper
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 9c5735f773922e580bf98c7c7dfda9bbed4c5191
$(PKG)_SUBDIR   := jasper-$($(PKG)_VERSION)
$(PKG)_FILE     := jasper-$($(PKG)_VERSION).zip
$(PKG)_URL      := http://www.ece.uvic.ca/~mdadams/jasper/software/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc jpeg

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.ece.uvic.ca/~mdadams/jasper/' | \
    grep 'jasper-' | \
    $(SED) -n 's,.*jasper-\([0-9][^>]*\)\.zip.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-libjpeg \
        --disable-opengl \
        --without-x
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
