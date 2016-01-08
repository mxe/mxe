# This file is part of MXE.
# See index.html for further information.

PKG             := jasper
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.900.1
$(PKG)_CHECKSUM := 6b905a9c2aca2e275544212666eefc4eb44d95d0a57e4305457b407fe63f9494
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
         $(MXE_CONFIGURE_OPTS) \
        --enable-libjpeg \
        --disable-opengl \
        --without-x
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=  LDFLAGS="-no-undefined"
endef
