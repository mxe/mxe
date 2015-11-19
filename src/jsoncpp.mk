# This file is part of MXE.
# See index.html for further information.

PKG             := jsoncpp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6.5
$(PKG)_CHECKSUM := ce0f245885fef62f2cbcbfbfe8a1267dc289b9c2d48fdbb90775c33d71fdc750
$(PKG)_DEPS     := gcc

$(PKG)_GH_REPO    := open-source-parsers/$(PKG)
$(PKG)_GH_TAG_PFX :=
$(PKG)_GH_TAG_SHA := d84702c
$(eval $(MXE_SETUP_GITHUB))

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DJSONCPP_WITH_POST_BUILD_UNITTEST=OFF \
        -DBUILD_STATIC_LIBS=$(if $(BUILD_STATIC),true,false) \
        -DBUILD_SHARED_LIBS=$(if $(BUILD_STATIC),false,true)
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install
endef
