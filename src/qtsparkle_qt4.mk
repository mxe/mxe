# This file is part of MXE.
# See index.html for further information.

PKG             := qtsparkle_qt4
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8882e6ef86cdb79db7932307309d005411fd0c20
$(PKG)_CHECKSUM := 86f6f010356e05e6efb956b5643ce587ffbbae45e8e7dc1b25b4b1dcf865b5f3
$(PKG)_SUBDIR   := qtsparkle-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/davidsansome/qtsparkle/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc qt

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, davidsansome/qtsparkle)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && '$(TARGET)-cmake' '$(1)' \
        -DBUILD_STATIC=$(CMAKE_STATIC_BOOL)
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'prefix=$(PREFIX)/$(TARGET)'; \
     echo 'exec_prefix=$${prefix}'; \
     echo 'libdir=$${exec_prefix}/lib'; \
     echo 'includedir=$${prefix}/include'; \
     echo ''; \
     echo 'Name: $(PKG)'; \
     echo 'Version: '; \
     echo 'Description: $(PKG)'; \
     echo 'Requires: QtCore QtGui QtNetwork QtXml'; \
     echo 'Libs: -L$${libdir} -lqtsparkle'; \
     echo 'Cflags: -I$${includedir}';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    $(TARGET)-g++ \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `$(TARGET)-pkg-config $(PKG) --cflags --libs`
endef
