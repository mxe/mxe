# This file is part of MXE.
# See index.html for further information.

PKG             := hdf5
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 867a91b75ee0bbd1f1b13aecd52e883be1507a2c
$(PKG)_SUBDIR   := hdf5-$($(PKG)_VERSION)
$(PKG)_FILE     := hdf5-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.hdfgroup.org/ftp/HDF5/current/src/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib pthreads

define $(PKG)_UPDATE
    /bin/false
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --enable-cxx \
        --disable-direct-vfd \
        --prefix='$(PREFIX)/$(TARGET)' \
        CPPFLAGS="-DH5_HAVE_WIN32_API -D__MSVCRT_VERSION__=0x0800" \
        LIBS="-lmsvcr80" \
        AR='$(TARGET)-ar'
    $(MAKE) -C '$(1)'/src -j '$(JOBS)'
    $(MAKE) -C '$(1)'/src -j 1 install
    $(MAKE) -C '$(1)'/c++/src -j '$(JOBS)'
    $(MAKE) -C '$(1)'/c++/src -j 1 install
    $(MAKE) -C '$(1)'/hl/src -j '$(JOBS)'
    $(MAKE) -C '$(1)'/hl/src -j 1 install
    $(MAKE) -C '$(1)'/hl/c++/src -j '$(JOBS)'
    $(MAKE) -C '$(1)'/hl/c++/src -j 1 install
endef
