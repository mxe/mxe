# This file is part of MXE.
# See index.html for further information.
#
# Build the graphviz libraries, most plugins and application (notably 'dot').
#
# NOTES:
#
# * Before using graphviz (application or library), a configration file
#   called 'config6' must be created in the directory that also contains the
#   libraries. This can be achieved by running 'dot -c', where dot is the
#   cross-compiled dot program. Note that this requires write privileges in the
#   MXE-installation directory. This can also be achieved on the build system
#   by invoking 'wine /path/to/mxe/targetdir/bin/dot -c'. (This is not done as
#   part of this Makefile, since Wine cannot be used (see 'do not run target
#   executables with Wine' on https://mxe.cc/).
#
# * mman-win32 has been made a dependency and we make sure that the mman library
#   is linked in by passing LIBS=-lmman to configure. This library is needed for
#   the mmap and munmap functions. At present, graphviz' configure script only
#   checks for the availability of <sys/mman.h>. When found (as for MXE builds),
#   it defines HAVE_SYS_MMAN_H in config.h and erroneously assumes that these
#   functions are available in the C library. Linking against -lmman fixes this
#   problem.
#
# * At present, --disable-qt is passed to the graphviz configure script.
#   Enabling qt requires that CXXFLAGS=-fpermissive is passed to configure
#   to prevent the following compilation error:
#
#        ../../../cmd/gvedit/csettings.cpp: In function 'QString findAttrFile()':
#        ../../../cmd/gvedit/csettings.cpp:43:23: error: invalid conversion from
#        'QString (*)()' to 'LPCVOID' {aka 'const void*'} [-fpermissive]
#        43 |     if (VirtualQuery (&findAttrFile, &mbi, sizeof(mbi)) == 0) {
#           |                       ^~~~~~~~~~~~~
#           |                       |
#           |                       QString (*)()
#
#   When enabling qt support, qt (or just qt-base?) should also be added to the
#   $(PKG)_DEPS variable below.
#
# * At present, --disable-perl is passed to the graphviz configure script.
#   On an OpenSUSE Tumbleweed test system, enabling perl results in the
#   inclusion of /usr/lib/perl5/5.34.1/x86_64-linux-thread-multi/CORE/perl.h,
#   which includes <sys/wait.h>. Since this file is not available for MXE builds,
#   this results in a compilation error. This requires somebody with a better
#   understanding of Perl.

PKG             := graphviz
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.0.0
$(PKG)_CHECKSUM := 500231f19651455623b9cee0bff93b3dd884df31ec85f7d1436726121f6b7bd1
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/5.0.0/graphviz-5.0.0.tar.gz
$(PKG)_DEPS     := gcc mman-win32 cairo devil expat freetype fontconfig gd ghostscript libwebp pango poppler

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
		--disable-swig \
		--disable-sharp \
		--disable-d \
		--disable-go \
		--disable-guile \
		--disable-io \
		--disable-java \
		--disable-javascript \
		--disable-lua \
		--disable-ocaml \
		--disable-perl \
		--disable-php \
		--disable-python \
		--disable-python3 \
		--disable-r \
		--disable-ruby \
		--disable-tcl \
		\
		--without-demos \
		--with-expat \
		--with-devil \
		--with-webp \
		--with-poppler \
		--without-rsvg \
		--with-ghostscrip \
		--without-visio \
		--with-pangocairo \
		--without-lasi \
		--with-freetype2 \
		--with-fontconfig \
		--without-gdk \
		--without-gtk-pixbuf \
		--without-gtk \
		--without-gtkgl \
		--without-gtkglext \
		--without-gts \
		--without-ann \
		--without-glade \
		--without-qt \
		--without-quartz \
		--with-gdiplus \
		--with-libgd \
		--without-glut \
		--with-sfdp \
		--with-smyrna \
		--with-cworthoqt \
		--with-digcola \
		--with-ipsepcola \
		\
		LIBS=-lmman
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' V=1
    $(MAKE) -C '$(BUILD_DIR)' install
endef
