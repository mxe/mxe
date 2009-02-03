# proj
# http://trac.osgeo.org/proj/

PKG            := proj
$(PKG)_VERSION := 4.6.1
$(PKG)_SUBDIR  := proj-$($(PKG)_VERSION)
$(PKG)_FILE    := proj-$($(PKG)_VERSION).tar.gz
$(PKG)_URL     := http://download.osgeo.org/proj/$($(PKG)_FILE)
$(PKG)_URL_2   := ftp://ftp.remotesensing.org/proj/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://trac.osgeo.org/proj/' | \
    $(SED) -n 's,.*proj-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,install-exec-local[^:],,' -i '$(1)/src/Makefile.in'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
