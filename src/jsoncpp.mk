# This file is part of MXE.
# See index.html for further information.

PKG             := jsoncpp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6.5
$(PKG)_CHECKSUM := a8354732489a4e3bf95ba801a300032e731b5aa8
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/open-source-parsers/jsoncpp/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/open-source-parsers/jsoncpp/archive/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/"\.tar.*,\1,p' | \
    sort | uniq | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DJSONCPP_WITH_POST_BUILD_UNITTEST=OFF \
        -DBUILD_STATIC_LIBS=$(if $(BUILD_STATIC),true,false) \
        -DBUILD_SHARED_LIBS=$(if $(BUILD_STATIC),false,true)
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install
endef
