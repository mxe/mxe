# This file is part of MXE.
# See index.html for further information.

PKG             := picomodel
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := dda03a87ec16ce7fa08be8342490e26bd25c101b
$(PKG)_SUBDIR   := picomodel-$($(PKG)_VERSION)
$(PKG)_FILE     := picomodel-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://picomodel.googlecode.com/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/ufoai/picomodel/commits/master' | \
    $(SED) -n 's#.*<span class="sha">\([^<]\{7\}\)[^<]\{3\}<.*#\1#p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

