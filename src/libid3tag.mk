# This file is part of MXE.
# See index.html for further information.

PKG             := libid3tag
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.15.1b
$(PKG)_CHECKSUM := 63da4f6e7997278f8a3fef4c6a372d342f705051d1eeb6a46a86b03610e26151
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/mad/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/mad/files/libid3tag/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)

    # libtool misses some dependency libs and there's no lt_cv* etc. options
    # can be removed after 0.15.1b if recent libtool et al. is used
    $(if $(BUILD_SHARED),\
        $(SED) -i 's#^postdeps=""#postdeps="-lz"#g' '$(1)/libtool')

    $(MAKE) -C '$(1)' -j '$(JOBS)' install LDFLAGS='-no-undefined'
endef
