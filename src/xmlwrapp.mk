# xmlwrapp
# http://sourceforge.net/projects/xmlwrapp/

PKG            := xmlwrapp
$(PKG)_VERSION := 0.6.0
$(PKG)_SUBDIR  := xmlwrapp-$($(PKG)_VERSION)
$(PKG)_FILE    := xmlwrapp-$($(PKG)_VERSION).tar.gz
$(PKG)_URL     := http://$(SOURCEFORGE_MIRROR)/xmlwrapp/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc libxml2 libxslt

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=142403&package_id=156331' | \
    grep 'xmlwrapp-' | \
    $(SED) -n 's,.*xmlwrapp-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        PKG_CONFIG='$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= html_DATA=
endef
