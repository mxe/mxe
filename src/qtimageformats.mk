# This file is part of MXE.
# See index.html for further information.

PKG             := qtimageformats
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := c97fee00c602f9f089fea480546d6e9d61a2b2297c2f163bfd9f8aba92b754a5
$(PKG)_SUBDIR    = $(subst qtbase,qtimageformats,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtimageformats,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtimageformats,$(qtbase_URL))
$(PKG)_DEPS     := gcc libmng qtbase tiff

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
