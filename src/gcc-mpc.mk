# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# MPC for GCC
PKG             := gcc-mpc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.8.1
$(PKG)_CHECKSUM := 5ef03ca7aee134fe7dfecb6c9d048799f0810278
$(PKG)_SUBDIR   := mpc-$($(PKG)_VERSION)
$(PKG)_FILE     := mpc-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.multiprecision.org/
$(PKG)_URL      := $($(PKG)_WEBSITE)/mpc/download/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    wget -q --no-check-certificate -O- 'https://gforge.inria.fr/scm/viewvc.php/tags/?root=mpc&sortby=date' | \
    $(SED) -n 's,.*<a name="\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef
