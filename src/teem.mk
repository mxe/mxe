# This file is part of MXE.
# See index.html for further information.

PKG             := teem
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := f63ff41111ca5aa6ff6fc7653ec0e089da61bac6
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)-src
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION)-src.tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib bzip2 pthreads levmar

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake . \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DTeem_PNG=OFF \
        -DQNANHIBIT_VALUE=1 -DQNANHIBIT_VALUE__TRYRUN_OUTPUT=1
    $(MAKE) -C '$(1)' -j '$(JOBS)' install VERBOSE=1
endef
