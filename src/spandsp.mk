# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := spandsp
$(PKG)_WEBSITE  := https://www.soft-switch.org
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.0.6
$(PKG)_CHECKSUM := cc053ac67e8ac4bb992f258fd94f275a7872df959f6a87763965feabfdcc9465
$(PKG)_SUBDIR   := spandsp-0.0.6
$(PKG)_FILE     := spandsp-$($(PKG)_VERSION).tar.gz
# Due to frequent downtime of soft-switch.org several project have created mirrors
# Use gstreamer mirror as it is the most stable one
$(PKG)_URL      := https://gstreamer.freedesktop.org/src/mirror/$($(PKG)_FILE)
$(PKG)_DEPS     := cc tiff

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://download.soft-switch.org/downloads/spandsp/' | \
    grep '<a href="spandsp-' | \
    $(SED)  -n "s,.*spandsp-\([0-9]\+\.[0-9]*[02468]\.[^']*\)\.tgz.*,\1,p" | \
    $(SORT) -Vr |\
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -i && ./configure \
    $(subst docdir$(comma),,$(MXE_CONFIGURE_OPTS)) \
        LIBS="`'$(TARGET)-pkg-config' --libs libtiff-4`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_CRUFT)
endef
