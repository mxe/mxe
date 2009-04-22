# PCRE

PKG             := pcre
$(PKG)_VERSION  := 7.9
$(PKG)_CHECKSUM := a4a34f71313ac042455355c01ad851791971a7fa
$(PKG)_SUBDIR   := pcre-$($(PKG)_VERSION)
$(PKG)_FILE     := pcre-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.pcre.org/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/pcre/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=10194&package_id=9960' | \
    grep 'pcre-' | \
    $(SED) -n 's,.*pcre-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,__declspec(dllimport),,' -i '$(1)/pcre.h.in'
    $(SED) 's,__declspec(dllimport),,' -i '$(1)/pcreposix.h'
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) 's,cross_compiling=no,cross_compiling=yes,' -i '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-utf8 \
        --enable-unicode-properties \
        --disable-pcregrep-libz \
        --disable-pcregrep-libbz2 \
        --disable-pcretest-libreadline
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
