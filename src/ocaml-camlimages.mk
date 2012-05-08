# This file is part of MXE.
# See index.html for further information.

PKG             := ocaml-camlimages
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 18288b2a9ecd8be71f004303cde23f34ffa7c1c5
PARAM := wget -q -O- 'https://bitbucket.org/camlspotter/camlimages/downloads' | sed -n 's,.*camlspotter/camlimages/src/\(.*\)">caml.*,\1,ip'
$(PKG)_REVISION := $(shell $(PARAM))
$(PKG)_SUBDIR   := camlspotter-camlimages-$($(PKG)_REVISION)
$(PKG)_FILE     := camlimages-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://bitbucket.org/camlspotter/camlimages/get/$($(PKG)_FILE)
$(PKG)_DEPS     := ocaml-core ocaml-findlib

define $(PKG)_UPDATE
	wget -q -O- 'https://bitbucket.org/camlspotter/camlimages/downloads' | \
	$(SED) -n 's,.*camlimages-\([0-9][^>]*\)\.tar.*,\1,ip' | \
	head -1
endef

define $(PKG)_BUILD
	bonjour tata
	# ne marche pas : ./configure --prefix /home/performance/src/mxe/usr/i686-pc-mingw32 --with-lablgtk2 --host i686-pc-mingw32
	# ok mais utilise omake :
	omake
endef
