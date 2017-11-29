# This file is part of MXE. See LICENSE.md for licensing information.

PKG            := python3-conf
$(PKG)_VERSION := 1
$(PKG)_UPDATE  := echo 1
$(PKG)_TARGETS := $(BUILD) $(MXE_TARGETS)
SYS_PYTHON3    := $(shell PATH="$(ORIG_PATH)" which python3)
PY3_XY_VER     := $(shell $(SYS_PYTHON3) -c "import sys; print('{0[0]}.{0[1]}'.format(sys.version_info))")

define $(PKG)_BUILD
    ln -sf '$(PREFIX)/$(BUILD)/bin/python3' '$(PREFIX)/bin/$(TARGET)-python3'
endef

define $(PKG)_BUILD_$(BUILD)
    #create python3 wrapper in a directory which is in PATH
    echo $(SYS_PYTHON3)
    (echo '#!/bin/sh'; \
     echo 'PYTHONPATH="$(PREFIX)/$(TARGET)/lib/python$(PY3_XY_VER)/site-packages" \
           exec $(SYS_PYTHON3) "$$@"';) \
             > '$(PREFIX)/$(TARGET)/bin/python3'
    chmod 0755 '$(PREFIX)/$(TARGET)/bin/python3'

    mkdir -p "$(PREFIX)/$(TARGET)/lib/python$(PY3_XY_VER)/site-packages"
endef