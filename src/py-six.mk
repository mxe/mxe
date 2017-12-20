# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := py-six
$(PKG)_WEBSITE  := https://pypi.python.org/pypi/six
$(PKG)_DESCR    := Python 2 and 3 compatibility utilities
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.11.0
$(PKG)_CHECKSUM := 927dc6fcfccd4e32e1ce161a20bf8cda39d8c9d5f7a845774486907178f69bd4
$(PKG)_GH_CONF  := benjaminp/six
$(PKG)_DEPS     := python-conf
$(PKG)_TARGETS  := $(BUILD)

define $(PKG)_BUILD
    # install python library
    cd '$(SOURCE_DIR)' && python setup.py install \
        --prefix='$(PREFIX)/$(TARGET)'
endef
