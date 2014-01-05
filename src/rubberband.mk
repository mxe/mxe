# This file is part of MXE.
# See index.html for further information.

PKG             := rubberband
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.1
$(PKG)_CHECKSUM := ae1faaef211d612db745d66d77266cf6789fd4ee
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://code.breakfastquay.com/attachments/download/34/$(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_DEPS     := gcc libsamplerate libsndfile vamp-plugin-sdk pthreads fftw

define $(PKG)_UPDATE
     echo $($(PKG)_VERSION) 
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -f -i
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -j $(JOBS) -C '$(1)' -j 1 install
endef
