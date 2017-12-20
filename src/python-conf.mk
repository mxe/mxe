# This file is part of MXE. See LICENSE.md for licensing information.

PKG            := python-conf
$(PKG)_VERSION := 1
$(PKG)_UPDATE  := echo 1
$(PKG)_TARGETS := $(BUILD)
SYS_PYTHON     := $(shell PATH="$(ORIG_PATH)" which python)
PY_XY_VER      := $(shell $(SYS_PYTHON) -c "import sys; print('{0[0]}.{0[1]}'.format(sys.version_info))")

define $(PKG)_BUILD_$(BUILD)
    #create python wrapper in a directory which is in PATH
    echo $(SYS_PYTHON)
    (echo '#!/bin/sh'; \
     echo 'PYTHONPATH="$(PREFIX)/$(TARGET)/lib/python$(PY_XY_VER)/site-packages" \
           exec $(SYS_PYTHON) "$$@"';) \
             > '$(PREFIX)/$(TARGET)/bin/python'
    chmod 0755 '$(PREFIX)/$(TARGET)/bin/python'

    mkdir -p "$(PREFIX)/$(TARGET)/lib/python$(PY_XY_VER)/site-packages"
endef
