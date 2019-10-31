# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtwinextras
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := e94d70f68dacbcfa2bb0cbe53c7024083b16d5d44806c107fe268d34028cb779
$(PKG)_SUBDIR    = $(subst qtbase,qtwinextras,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtwinextras,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtwinextras,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase qtdeclarative qtmultimedia

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' \
        -after \
        'LIBS_PRIVATE += -lgdi32'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
