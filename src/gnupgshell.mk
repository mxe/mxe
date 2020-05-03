# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gnupgshell
$(PKG)_WEBSITE  := http://coincodile.com/wb/products/gnupgshell
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.2
$(PKG)_CHECKSUM := cde30f9b4507ac196c9cc409a25933c8846df7ce6a7f9c7121b14fef6f505587
$(PKG)_SUBDIR   := gnupgshell-$($(PKG)_VERSION)
$(PKG)_FILE     := gnupgshell-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://codeload.github.com/coincodile/gnupgshell/tar.gz/$($(PKG)_VERSION)
$(PKG)_DEPS     := wxwidgets libgcrypt
# TODO: we have to add gpg2 as application

define $(PKG)_BUILD
	# Configure project
	cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-wx-config="$(PREFIX)/bin/$(TARGET)-wx-config" \
        --disable-doc \
        CXXFLAGS='-std=gnu++11' \
        CXXCPP='$(TARGET)-g++ -E -std=gnu++11'
    #-I</home/foo/sw/include>
    # Build
    $(MAKE) -C '$(1)' -j 1 clean
    $(MAKE) -C '$(1)' -j $(JOBS)
    $(MAKE) -C '$(1)' -j 1 install
endef
