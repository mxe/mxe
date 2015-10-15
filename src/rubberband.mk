# This file is part of MXE.
# See index.html for further information.

PKG             := rubberband
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.1
$(PKG)_CHECKSUM := ff0c63b0b5ce41f937a8a3bc560f27918c5fe0b90c6bc1cb70829b86ada82b75
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://code.breakfastquay.com/attachments/download/34/$(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_DEPS     := gcc fftw libsamplerate libsndfile pthreads vamp-plugin-sdk

define $(PKG)_UPDATE
    echo 'TODO: Updates for package rubberband need to be written.' >&2;
    echo $(rubberband_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -j $(JOBS) -C '$(1)' -j '$(JOBS)' \
        AR='$(TARGET)-ar' \
        RANLIB='$(TARGET)-ranlib' \
        DYNAMIC_EXTENSION='.dll' \
        DYNAMIC_FULL_VERSION= \
        DYNAMIC_ABI_VERSION= \
        lib vamp \
        $(if $(BUILD_STATIC),static,dynamic)

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/$(PKG)'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/vamp'
    $(INSTALL) -m644 '$(1)/$(PKG)/'* '$(PREFIX)/$(TARGET)/include/$(PKG)'
    $(INSTALL) -m644 '$(1)/lib/lib$(PKG).$(LIB_SUFFIX)' '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/lib/vamp-'*.dll '$(PREFIX)/$(TARGET)/lib/vamp'
    $(INSTALL) -m644 '$(1)/vamp/vamp-rubberband.cat' '$(PREFIX)/$(TARGET)/lib/vamp'
    $(SED) 's,%PREFIX%,$(PREFIX)/$(TARGET),' '$(1)/$(PKG).pc.in' \
        > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'
endef
