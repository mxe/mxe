# This file is part of MXE.
# See index.html for further information.

PKG             := polarssl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.9
$(PKG)_CHECKSUM := d3605afc28ed4b7d1d9e3142d72e42855e4a23c07c951bbb0299556b02d36755
$(PKG)_SUBDIR   := polarssl-$($(PKG)_VERSION)
$(PKG)_FILE     := polarssl-$($(PKG)_VERSION)-gpl.tgz
$(PKG)_URL      := https://polarssl.org/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

# Match lines like:
# <a href="/tech-updates/releases/polarssl-1.3.4-released">PolarSSL 1.3.4 released</a></br>
# On the releases page of polarssl for update

define $(PKG)_UPDATE
    $(WGET) -q -O- https://polarssl.org/tech-updates/releases | \
    $(SED) -n "s,.*releases/polarssl\-\([0-9]\.[0-9].[0-9]\)-released.*,\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'
    $(MAKE) -C '$(1)/build/library' -j '$(JOBS)' install
    $(MAKE) -C '$(1)/build/include' -j '$(JOBS)' install
endef
