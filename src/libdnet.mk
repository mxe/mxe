# libdnet

PKG            := libdnet
$(PKG)_VERSION := 1.11
$(PKG)_SUBDIR  := libdnet-$($(PKG)_VERSION)
$(PKG)_FILE    := libdnet-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE := http://libdnet.sourceforge.net/
$(PKG)_URL     := http://$(SOURCEFORGE_MIRROR)/libdnet/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc winpcap

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=36243&package_id=28560' | \
    grep 'libdnet-' | \
    $(SED) -n 's,.*libdnet-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,CYGWIN=no,CYGWIN=yes,g'                     -i '$(1)/configure'
    $(SED) 's,cat /proc/sys/kernel/ostype,,g'             -i '$(1)/configure'
    $(SED) 's,test -d /usr/include/mingw,true,'           -i '$(1)/configure'
    $(SED) 's,Iphlpapi,iphlpapi,g'                        -i '$(1)/configure'
    $(SED) 's,packet.lib,libpacket.a,'                    -i '$(1)/configure'
    $(SED) 's,-lpacket,-lpacket -lws2_32,g'               -i '$(1)/configure'
    $(SED) 's,/usr/include,$(PREFIX)/$(TARGET)/include,g' -i '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
