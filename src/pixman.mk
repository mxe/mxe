# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# pixman
PKG             := pixman
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.21.2
$(PKG)_CHECKSUM := c0ff07d7e4877dd4d0d369ca09e50ca956e3386e
$(PKG)_SUBDIR   := pixman-$($(PKG)_VERSION)
$(PKG)_FILE     := pixman-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://cairographics.org/
$(PKG)_URL      := http://cairographics.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://cairographics.org/releases/?C=M;O=D' | \
    $(SED) -n 's,.*"pixman-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
