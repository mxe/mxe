# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# libsamplerate
PKG             := libsamplerate
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.7
$(PKG)_CHECKSUM := 98a52392eb97f9ba724ca024b3af29a8a0cc0206
$(PKG)_SUBDIR   := libsamplerate-$($(PKG)_VERSION)
$(PKG)_FILE     := libsamplerate-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.mega-nerd.com/SRC
$(PKG)_URL      := http://www.mega-nerd.com/SRC/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.mega-nerd.com/SRC/download.html' | \
    $(SED) -n 's,.*libsamplerate-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v alpha | \
    grep -v beta | \
    head -1
endef

define $(PKG)_BUILD
    # wine confuses the cross-compiling detection, so set it explicitly
    #$(SED) 's,cross_compiling=no,cross_compiling=yes,' -i '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
