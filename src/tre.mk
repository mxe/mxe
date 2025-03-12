# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := tre
$(PKG)_WEBSITE  := https://laurikari.net/tre/
$(PKG)_DESCR    := TRE
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.0
$(PKG)_CHECKSUM := 5b7e5a730f041c6b0dab8f66576cda917577ec06bb393f156b169c51bca170d1
$(PKG)_GH_CONF  := laurikari/tre/tags,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-nls
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

$(PKG)_BUILD_SHARED =
