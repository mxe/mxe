# This file is part of MXE. See LICENSE.md for licensing information.

PKG              := meson
$(PKG)_WEBSITE   := https://mesonbuild.com/
$(PKG)_DESCR     := An open source build system meant to be extremely fast and as user friendly as possible.
$(PKG)_IGNORE    :=
$(PKG)_VERSION   := 0.43.0
$(PKG)_CHECKSUM  := 324894427dcd29f6156fe06b046c6ad1b998470714debd7c5705902f21aaaa73
$(PKG)_GH_CONF   := mesonbuild/meson/releases/latest
$(PKG)_SUBDIR    := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE      := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL       := https://github.com/mesonbuild/meson/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_FILE_DEPS := $(wildcard $(PWD)/plugins/meson/conf/*)
$(PKG)_DEPS      := python3-conf ninja
$(PKG)_TARGETS   := $(BUILD) $(MXE_TARGETS)

define $(PKG)_BUILD
    # create the Meson cross file
    mkdir -p '$(PREFIX)/$(TARGET)/share/meson'
    cmake-configure-file \
        -DLIBTYPE=$(if $(BUILD_SHARED),shared,static) \
        -DPREFIX=$(PREFIX) \
        -DTARGET=$(TARGET) \
        -DBUILD=$(BUILD) \
        -DCPU_FAMILY=$(strip \
             $(if $(findstring x86_64,$(TARGET)),x86_64,\
             $(if $(findstring i686,$(TARGET)),x86))) \
        -DCPU=$(strip \
             $(if $(findstring x86_64,$(TARGET)),x86_64,\
             $(if $(findstring i686,$(TARGET)),i686))) \
        -DINPUT='$(PWD)/plugins/meson/conf/mxe-crossfile.meson.in' \
        -DOUTPUT='$(PREFIX)/$(TARGET)/share/meson/mxe-crossfile.meson'

    # create the prefixed Meson wrapper script
    cmake-configure-file \
        -DPATH='$(PREFIX)/$(BUILD)/bin:$(PREFIX)/bin' \
        -DLIBTYPE=$(if $(BUILD_SHARED),shared,static) \
        -DPREFIX=$(PREFIX) \
        -DTARGET=$(TARGET) \
        -DBUILD=$(BUILD) \
        -DMESON_CROSS_FILE='$(PREFIX)/$(TARGET)/share/meson/mxe-crossfile.meson' \
        -DINPUT='$(PWD)/plugins/meson/conf/target-meson.in' \
        -DOUTPUT='$(PREFIX)/bin/$(TARGET)-meson'
    chmod 0755 '$(PREFIX)/bin/$(TARGET)-meson'
endef

define $(PKG)_BUILD_$(BUILD)
    cd '$(SOURCE_DIR)' && python3 setup.py install \
        --prefix='$(PREFIX)/$(TARGET)'

    # Awful hacks: we must hijack the python entry points here to install our
    # site-packages path. This is because Meson is going to put the path to the
    # real python interpreter and script it's been invoked with into the build
    # rules file, bypassing any of our shell wrappers. This causes automatic
    # reconfiguration to fail.

    for prog in meson{,conf,introspect,test} wraptool; do \
        $(SED) '1d' '$(PREFIX)/$(TARGET)'/bin/$${prog} > '$(1)'/$${prog}.tail; \
        echo "#!/usr/bin/env python3" > '$(PREFIX)/$(TARGET)'/bin/$${prog}; \
        echo "__mxe_python_path = r'''" >> '$(PREFIX)/$(TARGET)'/bin/$${prog}; \
        echo '$(PREFIX)/$(TARGET)/lib/python$(PY3_XY_VER)/site-packages' >> '$(PREFIX)/$(TARGET)'/bin/$${prog}; \
        echo "'''[1:-1]" >> '$(PREFIX)/$(TARGET)'/bin/$${prog}; \
        echo 'import sys; sys.path.insert(1, __mxe_python_path)' >> '$(PREFIX)/$(TARGET)'/bin/$${prog}; \
        echo "__mxe_path = r'''" >> '$(PREFIX)/$(TARGET)'/bin/$${prog}; \
        echo '$(PREFIX)/$(BUILD)/bin:$(PREFIX)/bin' >> '$(PREFIX)/$(TARGET)'/bin/$${prog}; \
        echo "'''[1:-1]" >> '$(PREFIX)/$(TARGET)'/bin/$${prog}; \
        echo 'import os; os.environ["PATH"] = "{0}:{1}".format(__mxe_path, os.environ["PATH"])' >> '$(PREFIX)/$(TARGET)'/bin/$${prog}; \
        cat '$(1)'/$${prog}.tail >> '$(PREFIX)/$(TARGET)'/bin/$${prog}; \
        cat '$(PREFIX)/$(TARGET)'/bin/$${prog}; \
    done
endef
