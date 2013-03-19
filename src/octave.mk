# This file is part of MXE.
# See index.html for further information.

PKG             := octave
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 3cc9366b6dbbd336eaf90fe70ad16e63705d82c4
$(PKG)_SUBDIR   := octave-$($(PKG)_VERSION)
$(PKG)_FILE     := octave-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := blas curl fftw fltk freetype gcc glpk gnuplot graphicsmagick hdf5 lapack libgomp pcre pthreads qhull qrupdate qt readline suitesparse texinfo zlib
## arpack fontconfig pstoedit qscintilla ### FIXME: these are dependencies for Octave, but do not build yet

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/octave/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="octave-\([0-9][^"]*\)\.tar\.gz".*,\1,p' | \
    head -1
endef


define $(PKG)_BUILD

    ### make sure pcre-config of host is used
    $(SED) -i 's,pcre-config,$(PREFIX)/$(TARGET)/bin/pcre-config,g' '$(1)'/configure

    # configure
    cd    '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-static \
	--enable-openmp

    # make
    $(MAKE) -C '$(1)'	

    # install 
    $(MAKE) -C '$(1)' install	

endef

$(PKG)_BUILD_x86_64-w64-mingw32 =
