# This file is part of MXE.
# See index.html for further information.

PKG             := libtasn1
$(PKG)_VERSION  := 4.8
$(PKG)_CHECKSUM := fa802fc94d79baa00e7397cedf29eb6827d4bd8b4dd77b577373577c93a8c513
$(PKG)_SUBDIR   := libtasn1-$($(PKG)_VERSION)
$(PKG)_FILE     := libtasn1-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnu.org/gnu/libtasn1/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc 

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
#        --disable-rpath \
        CPPFLAGS='-DWINVER=0x0600 \
        LIBS='-lws2_32' \
        ac_cv_prog_AR='$(TARGET)-ar'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef

