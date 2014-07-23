# This file is part of MXE.
# See index.html for further information.

PKG             := qwt_qt4
$(PKG)_VERSION   = $(qwt_VERSION)
$(PKG)_CHECKSUM  = $(qwt_CHECKSUM)
$(PKG)_SUBDIR    = $(qwt_SUBDIR)
$(PKG)_FILE      = $(qwt_FILE)
$(PKG)_WEBSITE   = $(qwt_WEBSITE)
$(PKG)_URL       = $(qwt_URL)
$(PKG)_DEPS     := gcc qt

define $(PKG)_UPDATE
    echo $(qwt_VERSION)
endef

define $(PKG)_BUILD
    $(SED) -i '/\INSTALLBASE /s%\INSTALLBASE .*%INSTALLBASE=$(PREFIX)/$(TARGET)/qwt-$(qwt_VERSION)%g' '$(1)/qwtconfig.pri'
    $(if $(BUILD_STATIC),\
        echo "QWT_CONFIG -= QwtDll" >> '$(1)/qwtconfig.pri')
    # build
    cd '$(1)/src' && $(PREFIX)/$(TARGET)/qt/bin/qmake
    $(MAKE) -C '$(1)/src' -f 'Makefile.Release' -j '$(JOBS)' install
endef
