# This file is part of MXE.
# See index.html for further information.

PKG             := aubio
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.3.2
$(PKG)_CHECKSUM := 8ef7ccbf18a4fa6db712a9192acafc9c8d080978
$(PKG)_SUBDIR   := aubio-$($(PKG)_VERSION)
$(PKG)_FILE     := aubio-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.aubio.org/pub/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc fftw libsamplerate libsndfile

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.aubio.org/download' | \
    $(SED) -n 's,.*aubio-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --disable-jack \
        --prefix='$(PREFIX)/$(TARGET)' \
        PYTHON='no'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

$(PKG)_BUILD_SHARED =
