# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := xmlsec
$(PKG)_WEBSITE  := https://www.aleksey.com/xmlsec/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.25
$(PKG)_CHECKSUM := 5a2d400043ac5b2aa84b66b6b000704f0f147077afc6546d73181f5c71019985
$(PKG)_GH_CONF  := lsh123/xmlsec/tags,xmlsec-,,,_
$(PKG)_DEPS     := cc libltdl libxml2 libxslt openssl gnutls

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-docs=no \
        --enable-apps=no \
        --enable-shared=$(if $(BUILD_STATIC),no,yes) \
        --enable-static=$(if $(BUILD_STATIC),yes,no)

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1 $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1 $(MXE_DISABLE_CRUFT)
endef
