# This file is part of MXE.
# See index.html for further information.

PKG             := vc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.0
$(PKG)_CHECKSUM := 11db4d2085a5201b05f383b504d9d818910d9406b47adc893dc08fac306c06e6
$(PKG)_SUBDIR   := Vc-$($(PKG)_VERSION)
$(PKG)_FILE     := Vc-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://github.com/VcDevel/Vc/releases/download/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

$(PKG)_UPDATE    = $(call MXE_GET_GITHUB_SHA, kisli/vmime, master) | $(SED) 's/^\(.......\).*/\1/;'

define $(PKG)_BUILD
    cd '$(1)' && mkdir build && cd build && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_SYSTEM_PROCESSOR=x86

    $(MAKE) -C '$(1)'/build -j '$(JOBS)' install VERBOSE=1

endef
