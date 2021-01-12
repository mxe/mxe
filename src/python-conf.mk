# This file is part of MXE. See LICENSE.md for licensing information.

PKG            := python-conf
$(PKG)_VERSION := 1
$(PKG)_UPDATE  := echo 1
$(PKG)_TARGETS := $(BUILD)

PYTHON_SETUP_INSTALL = \
    cd '$(SOURCE_DIR)' && $(BUILD)-python$(PY_XY_VER) setup.py install \
        --prefix='$(PREFIX)/$(TARGET)' \
        --install-lib='$(PREFIX)/$(TARGET)/lib/python$(PY_XY_VER)/site-packages'

define $(PKG)_BUILD_$(BUILD)
    #create python wrapper in a directory which is in PATH
    (echo '#!/bin/sh'; \
     echo 'PYTHONPATH="$(PREFIX)/$(TARGET)/lib/python$(PY_XY_VER)/site-packages" \
           PYTHONDONTWRITEBYTECODE=True \
           exec $(PYTHON) "$$@"';) \
             > '$(PREFIX)/bin/$(TARGET)-python$(PY_XY_VER)'
    chmod 0755 '$(PREFIX)/bin/$(TARGET)-python$(PY_XY_VER)'

    mkdir -p "$(PREFIX)/$(TARGET)/lib/python$(PY_XY_VER)/site-packages"
    touch "$(PREFIX)/$(TARGET)/lib/python$(PY_XY_VER)/site-packages/.gitkeep"
endef
