# This file is part of MXE.
# See index.html for further information.

PKG             := picomodel
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := b82b16ee69edaefe751b678b577b90c1971ce4db
$(PKG)_SUBDIR   := ufoai-$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/ufoai/$(PKG)/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/ufoai/picomodel/commits/master' | \
    $(SED) -n 's#.*<span class="sha">\([^<]\{7\}\)[^<]\{3\}<.*#\1#p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./autogen.sh && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

