# This file is part of MXE.
# See index.html for further information.

PKG             := libmysqlclient
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.1.6
$(PKG)_CHECKSUM := 2222433012c415871958b61bc4f3683e1ebe77e3389f698b267058c12533ea78
$(PKG)_SUBDIR   := mysql-connector-c-$($(PKG)_VERSION)-src
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://dev.mysql.com/get/Downloads/Connector-C/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc openssl zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://dev.mysql.com/downloads/connector/c/' | \
    $(SED) -n 's,.*mysql-connector-c-\([0-9\.]\+\)-win.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # native build for tool comp_err
    # See https://bugs.mysql.com/bug.php?id=61340
    mkdir '$(1).native'
    cd '$(1).native' && cmake \
         '$(1)'
    $(MAKE) -C '$(1).native' -j '$(JOBS)' VERBOSE=1
    # cross-compilation
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
        -DCMAKE_INSTALL_PREFIX=$(PREFIX)/$(TARGET) \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DIMPORT_COMP_ERR='$(1).native/ImportCompErr.cmake' \
        -DHAVE_GCC_ATOMIC_BUILTINS=1 \
        -DDISABLE_SHARED=$(CMAKE_STATIC_BOOL) \
        -DENABLE_DTRACE=OFF \
        -DWITH_ZLIB=system \
        '$(1)'

    # def file created by cmake creates link errors
    $(if $(findstring i686-w64-mingw32.shared,$(TARGET)),
        cp '$(PWD)/src/$(PKG).def' '$(1).build/libmysql/libmysql_exports.def')

    $(MAKE) -C '$(1).build' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(1).build/include'  -j 1 install VERBOSE=1
    $(MAKE) -C '$(1).build/libmysql' -j 1 install VERBOSE=1
    $(MAKE) -C '$(1).build/scripts'  -j 1 install VERBOSE=1

    # no easy way to configure location of dll
    -mv '$(PREFIX)/$(TARGET)/lib/$(PKG).dll' '$(PREFIX)/$(TARGET)/bin/'

    # missing headers
    $(INSTALL) -m644 '$(1)/include/'thr_* '$(1)/include/'my_thr* '$(PREFIX)/$(TARGET)/include'

    # build test with mysql_config
    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(PREFIX)/$(TARGET)/bin/mysql_config' --cflags --libs`
endef
