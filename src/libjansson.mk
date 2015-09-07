# This file is part of MXE.
# See index.html for further information.

PKG             := libjansson
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.7
$(PKG)_CHECKSUM := 7d8686d84fd46c7c28d70bf2d5e8961bc002845e
$(PKG)_SUBDIR   := jansson-$($(PKG)_VERSION)
$(PKG)_FILE     := jansson-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.digip.org/jansson/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
	echo 'TODO: Updates for package libjansson need to be fixed.' >&2;
	echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
		$(MXE_CONFIGURE_OPTS)
		
	$(MAKE) -C '$(1)' -j '$(JOBS)'
	$(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_DOCS)
endef
