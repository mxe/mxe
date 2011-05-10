# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# cairomm
PKG             := cairomm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.10.0
$(PKG)_CHECKSUM := f08bf8a331067f0d1e876523f07238fba6b26b99
$(PKG)_SUBDIR   := cairomm-$($(PKG)_VERSION)
$(PKG)_FILE     := cairomm-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://cairographics.org/cairomm/
$(PKG)_URL      := http://cairographics.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc cairo libsigc++

define $(PKG)_UPDATE
    wget -q -O- 'http://cairographics.org/releases/?C=M;O=D' | \
    $(SED) -n 's,.*"cairomm-\([0-9][^"]*\)\.tar.*,\1,p' | \
    grep -v '^1\.8\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
