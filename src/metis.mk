# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# METIS
PKG             := metis
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.0
$(PKG)_CHECKSUM := 580568308e1fa40e5a7a77cacbf27f865d6c01af
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_WEBSITE  := http://glaros.dtc.umn.edu/gkhome/metis/metis/overview
$(PKG)_URL      := http://glaros.dtc.umn.edu/gkhome/fetch/sw/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://glaros.dtc.umn.edu/gkhome/metis/metis/download' | \
    $(SED) -n 's,.*metis-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,cc,$(TARGET)-gcc,'        '$(1)/Makefile.in'
    $(SED) -i 's,ar ,$(TARGET)-ar ,'       '$(1)/Makefile.in'
    $(SED) -i 's,ranlib,$(TARGET)-ranlib,' '$(1)/Makefile.in'
    $(MAKE) -C '$(1)/Lib' -j '$(JOBS)'
    $(INSTALL) -d                        '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libmetis.a'   '$(PREFIX)/$(TARGET)/lib/libmetis.a'
    $(INSTALL) -d                        '$(PREFIX)/$(TARGET)/include/metis/Lib'
    $(INSTALL) -m644 '$(1)/Lib/metis.h'  '$(PREFIX)/$(TARGET)/include/metis/Lib/metis.h'
    $(INSTALL) -m644 '$(1)/Lib/defs.h'   '$(PREFIX)/$(TARGET)/include/metis/Lib/defs.h'
    $(INSTALL) -m644 '$(1)/Lib/struct.h' '$(PREFIX)/$(TARGET)/include/metis/Lib/struct.h'
    $(INSTALL) -m644 '$(1)/Lib/macros.h' '$(PREFIX)/$(TARGET)/include/metis/Lib/macros.h'
    $(INSTALL) -m644 '$(1)/Lib/rename.h' '$(PREFIX)/$(TARGET)/include/metis/Lib/rename.h'
    $(INSTALL) -m644 '$(1)/Lib/proto.h'  '$(PREFIX)/$(TARGET)/include/metis/Lib/proto.h'
endef
