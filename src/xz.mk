# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := xz
$(PKG)_WEBSITE  := https://tukaani.org/xz/
$(PKG)_DESCR    := XZ
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.8.3
$(PKG)_CHECKSUM := 3d3a1b973af218114f4f889bbaa2f4c037deaae0c8e815eec381c3d546b974a0
$(PKG)_GH_CONF  := tukaani-project/xz/releases,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-threads \
        --disable-nls
    $(MAKE) -C '$(1)'/src/liblzma -j '$(JOBS)' install
endef
