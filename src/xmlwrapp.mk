# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# xmlwrapp
PKG             := xmlwrapp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.6.2
$(PKG)_CHECKSUM := b3ef8bff215bbacd988790615b76379672105928
$(PKG)_SUBDIR   := xmlwrapp-$($(PKG)_VERSION)
$(PKG)_FILE     := xmlwrapp-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://sourceforge.net/projects/xmlwrapp/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/xmlwrapp/xmlwrapp/$($(PKG)_VERSION)/$($(PKG)_FILE)
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
