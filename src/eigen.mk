# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# eigen
PKG             := eigen
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.16
$(PKG)_CHECKSUM := 16732775f93174563e575c3570395a11a5e57104
$(PKG)_SUBDIR   := $(PKG)-$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://eigen.tuxfamily.org/
$(PKG)_URL      := http://bitbucket.org/$(PKG)/$(PKG)/get/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://eigen.tuxfamily.org/index.php?title=Main_Page#Download' | \
    grep 'eigen/get/' | \
    $(SED) -n 's,.*eigen/get/\(2[^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && \
    cmake . -DCMAKE_TOOLCHAIN_FILE=$(PREFIX)/$(TARGET)/share/cmake/mingw-cross-env-conf.cmake 
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
