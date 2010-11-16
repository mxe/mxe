# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# metis
PKG             := metis
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.0
$(PKG)_CHECKSUM := 580568308e1fa40e5a7a77cacbf27f865d6c01af
$(PKG)_SUBDIR   := metis-4.0
$(PKG)_FILE     := metis-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://glaros.dtc.umn.edu
$(PKG)_URL      := http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-4.0.tar.gz
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.cise.ufl.edu/research/sparse/SuiteSparse/' | \
    $(SED) -n 's,.*metis-\([0-9]\.[0-9]\)\.tar.gz,\1,ip' | \
    head -1
endef

define $(PKG)_NO_BUILD
    # Don't build metis here, build inline with suitesparse instead
    # since it looks in an odd location for the headers
    # Change this to $(PKG)_BUILD to actually build and install
    $(SED) -i 's,cc,$(TARGET)-gcc,'        $(1)/Makefile.in
    $(SED) -i 's,ar ,$(TARGET)-ar ,'       $(1)/Makefile.in
    $(SED) -i 's,ranlib,$(TARGET)-ranlib,' $(1)/Makefile.in
    $(MAKE) -C '$(1)/Lib'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m664 '$(1)/libmetis.a'   '$(PREFIX)/$(TARGET)/lib/libmetis.a'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/metis/Lib'
    $(INSTALL) -m664 '$(1)/Lib/metis.h'  '$(PREFIX)/$(TARGET)/include/metis/Lib/metis.h'
    $(INSTALL) -m664 '$(1)/Lib/defs.h'   '$(PREFIX)/$(TARGET)/include/metis/Lib/defs.h'
    $(INSTALL) -m664 '$(1)/Lib/struct.h' '$(PREFIX)/$(TARGET)/include/metis/Lib/struct.h'
    $(INSTALL) -m664 '$(1)/Lib/macros.h' '$(PREFIX)/$(TARGET)/include/metis/Lib/macros.h'
    $(INSTALL) -m664 '$(1)/Lib/rename.h' '$(PREFIX)/$(TARGET)/include/metis/Lib/rename.h'
    $(INSTALL) -m664 '$(1)/Lib/proto.h'  '$(PREFIX)/$(TARGET)/include/metis/Lib/proto.h'
endef
