# This file is part of MXE.
# See index.html for further information.

PKG             := json_spirit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.08
$(PKG)_CHECKSUM := 082798e46b3ee4c2b9613c212308f770cd9988c7a08b8ae3c345bf64fdad125f
$(PKG)_SUBDIR   := $(PKG)_v$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)_v$($(PKG)_VERSION).zip

# The original source of this file at
# http://www.codeproject.com/KB/recipes/JSON_Spirit/json_spirit_v4.08.zip
# is behind a login screen. Use manually downloaded cache on the S3 bucket.
$(PKG)_URL       = $(PKG_MIRROR)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc boost

define $(PKG)_UPDATE
    echo 'TODO: json_spirit automatic update explicitly disabled. Please ' >&2;
    echo '      manually check and update.' >&2;
    echo 'Latest:' >&2;
    $(WGET) -q -O- 'http://www.codeproject.com/Articles/20027/JSON-Spirit-A-C-JSON-Parser-Generator-Implemented' | \
    $(SED) -n 's,.*/JSON_Spirit/json_spirit_v\([0-9.]*\)[.]zip.*".*,\1,p' | \
    head -1 >&2;
    echo 'Current:' >&2;
    echo $(json_spirit_VERSION) >&2;
    echo $(json_spirit_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && \
        cmake '$(1)' \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_RELEASE_POSTFIX='' \
        -DBoost_THREADAPI=win32
    $(MAKE) -C '$(1).build' -j '$(JOBS)' VERBOSE=1 || $(MAKE) -C '$(1)' -j 1 VERBOSE=1
    $(MAKE) -C '$(1).build' -j 1 install VERBOSE=1

    $(TARGET)-g++ \
        '$(1)/json_demo/json_demo.cpp' \
        -o '$(PREFIX)/$(TARGET)/bin/test-json_spirit.exe' -ljson_spirit
endef
