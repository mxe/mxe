# This file is part of MXE.
# See index.html for further information.

PKG             := gcc-mpc
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 229722d553030734d49731844abfef7617b64f1a
$(PKG)_SUBDIR   := mpc-$($(PKG)_VERSION)
$(PKG)_FILE     := mpc-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.multiprecision.org/mpc/download/$($(PKG)_FILE)
$(PKG)_URL_2    := http://ftp.debian.org/debian/pool/main/m/mpclib/mpclib_$($(PKG)_VERSION).orig.tar.gz
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    wget -q --no-check-certificate -O- 'https://gforge.inria.fr/scm/viewvc.php/tags/?root=mpc&sortby=date' | \
    $(SED) -n 's,.*<a name="\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

$(PKG)_BUILD_i686-static-mingw32   =
$(PKG)_BUILD_x86_64-static-mingw32 =
