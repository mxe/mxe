# CppUnit

PKG             := cppunit
$(PKG)_VERSION  := 1.12.1
$(PKG)_CHECKSUM := f1ab8986af7a1ffa6760f4bacf5622924639bf4a
$(PKG)_SUBDIR   := cppunit-$($(PKG)_VERSION)
$(PKG)_FILE     := cppunit-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://apps.sourceforge.net/mediawiki/cppunit/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/cppunit/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=11795&package_id=11019' | \
    grep 'cppunit-' | \
    $(SED) -n 's,.*cppunit-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
endef
