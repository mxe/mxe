# This file is part of MXE.
# See index.html for further information.

PKG             := netpbm
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := f9d07c0b82f5feed66a5e995b077492093aa24b5
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/netpbm/super_stable/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/netpbm/files/super_stable/' | \
    $(SED) -n 's,.*netpbm-\([0-9][^>]*\)\.tgz.*,\1,p' | \
    head -1
endef

# The Netpbm package has its own weird build system...
# Parallel builds don't work, so we use -j1 explicitly.

define $(PKG)_BUILD
    # Create a suitable configuration
    cp '$(1)/Makefile.config.in' '$(1)/Makefile.config'
    echo 'DEFAULT_TARGET=nonmerge'          >> '$(1)/Makefile.config'
    echo 'CC=$(TARGET)-gcc'                 >> '$(1)/Makefile.config'
    echo 'LD=$(TARGET)-gcc'                 >> '$(1)/Makefile.config'
    echo 'LINKERISCOMPILER=Y'               >> '$(1)/Makefile.config'
    echo 'LINKER_CAN_DO_EXPLICIT_LIBRARY=Y' >> '$(1)/Makefile.config'
    echo 'AR=$(TARGET)-ar'                  >> '$(1)/Makefile.config'
    echo 'RANLIB=$(TARGET)-ranlib'          >> '$(1)/Makefile.config'
    echo 'OMIT_NETWORK=y'                   >> '$(1)/Makefile.config'
    echo 'DONT_HAVE_PROCESS_MGMT=Y'         >> '$(1)/Makefile.config'
    echo 'NETPBMLIBTYPE=unixstatic'         >> '$(1)/Makefile.config'
    echo 'NETPBMLIBSUFFIX=a'                >> '$(1)/Makefile.config'
    # Build only the library
    $(MAKE) -C '$(1)' -j1 PROG_SUBDIRS=
    # Package everything into a package directory. Use '-i' to ignore
    # failures that happen because we did not build all the tools.
    $(MAKE) -C '$(1)' -j1 -i package pkgdir='$(1)/mxe-pkgdir'
    # Install only the library from that package directory
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/mxe-pkgdir/include/'* '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/mxe-pkgdir/link/libnetpbm.a' '$(PREFIX)/$(TARGET)/lib/'
endef
