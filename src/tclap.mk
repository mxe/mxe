# This file is part of MXE.
# See index.html for further information.

PKG             := tclap
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.1
$(PKG)_CHECKSUM := 9f9f0fe3719e8a89d79b6ca30cf2d16620fba3db5b9610f9b51dd2cd033deebb
$(PKG)_SUBDIR   := tclap-$($(PKG)_VERSION)
$(PKG)_FILE     := tclap-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/tclap/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/tclap/files/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
