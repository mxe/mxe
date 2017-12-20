# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := py-pyparsing
$(PKG)_WEBSITE  := https://pyparsing.wikispaces.com
$(PKG)_DESCR    := PyParsing -- A Python Parsing Module
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.0
$(PKG)_CHECKSUM := 0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04
$(PKG)_SUBDIR   := pyparsing-$($(PKG)_VERSION)
$(PKG)_FILE     := pyparsing-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/pyparsing/pyparsing/pyparsing-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := python-conf
$(PKG)_TARGETS  := $(BUILD)

$(PKG)_UPDATE = \
    $(call GET_LATEST_VERSION,https://pypi.python.org/pypi/pyparsing,pyparsing/,")

define $(PKG)_BUILD
    # install python library
    cd '$(SOURCE_DIR)' && python setup.py install \
        --prefix='$(PREFIX)/$(TARGET)'
endef
