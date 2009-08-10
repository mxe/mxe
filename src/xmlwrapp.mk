# xmlwrapp

PKG             := xmlwrapp
$(PKG)_VERSION  := 0.6.1
$(PKG)_CHECKSUM := af96d589bd13737080cd02620685c665f9807397
$(PKG)_SUBDIR   := xmlwrapp-$($(PKG)_VERSION)
$(PKG)_FILE     := xmlwrapp-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://sourceforge.net/projects/xmlwrapp/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/xmlwrapp/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libxml2 libxslt

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/xmlwrapp/files/xmlwrapp/) | \
    $(SED) -n 's,.*xmlwrapp-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        PKG_CONFIG='$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= html_DATA=
endef
