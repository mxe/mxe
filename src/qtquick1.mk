# This file is part of MXE.
# See index.html for further information.

PKG             := qtquick1
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 27d67436cd902bb8b89b5808e4cc4a34fd61ac75
$(PKG)_SUBDIR    = $(subst qtbase,qtquick1,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtquick1,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtquick1,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtscript qtsvg qttools qtxmlpatterns

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    # invoke qmake with removed debug options as a workaround for
    # https://bugreports.qt-project.org/browse/QTBUG-30898
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' CONFIG-='debug debug_and_release'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
