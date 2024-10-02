# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := graphene
$(PKG)_WEBSITE  := https://github.com/ebassi/$(PKG)
$(PKG)_DESCR    := A thin layer of graphic data types 
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.10.8
$(PKG)_CHECKSUM := 922dc109d2dc5dc56617a29bd716c79dd84db31721a8493a13a5f79109a4a4ed
$(PKG)_GH_CONF  := ebassi/graphene/releases
$(PKG)_DEPS     := cc meson-wrapper glib

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Dgcc_vector=false \
        -Dsse2=false \
        -Dtests=false \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
