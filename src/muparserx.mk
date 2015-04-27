# This file is part of MXE.
# See index.html for further information.

PKG             := muparserx
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.5
$(PKG)_CHECKSUM := d8f646aac4099973b70ae84e1c7cb411abb6fe0b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := http://sourceforge.net/projects/mxedeps/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
echo "TODO: write update for muparserx"
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
	-DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
	-DBUILD_SHARED_LIBS=$(if $(BUILD_STATIC),FALSE,TRUE) \
	-DCMAKE_CXX_FLAGS='-std=c++11' \
        '$(1)'	
	$(MAKE) -C '$(1).build' install

    rm -f $(PREFIX)/$(TARGET)/include/mpCompat.h

endef
