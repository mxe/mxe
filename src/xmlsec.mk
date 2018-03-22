# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := xmlsec
$(PKG)_WEBSITE  := https://www.aleksey.com/xmlsec/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.25
$(PKG)_CHECKSUM := 5a2d400043ac5b2aa84b66b6b000704f0f147077afc6546d73181f5c71019985
$(PKG)_GH_CONF  := lsh123/xmlsec/tags,xmlsec-,,,_
$(PKG)_DEPS     := cc libltdl libxml2 libxslt openssl gnutls

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
    	$(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(1)' -j 1 install VERBOSE=1
endef
