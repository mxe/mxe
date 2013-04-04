# This file is part of MXE.
# See index.html for further information.

PKG             := octave
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 3cc9366b6dbbd336eaf90fe70ad16e63705d82c4
$(PKG)_SUBDIR   := octave-$($(PKG)_VERSION)
$(PKG)_FILE     := octave-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := blas curl fftw fltk freetype gcc glpk graphicsmagick hdf5 lapack libgomp pcre pthreads qrupdate readline suitesparse texinfo zlib
## arpack fontconfig gnuplot pstoedit qhull qscintilla qt ### FIXME: these are dependencies for Octave, but do not build yet

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/octave/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="octave-\([0-9][^"]*\)\.tar\.gz".*,\1,p' | \
    head -1
endef


define $(PKG)_BUILD
    if [ $(BUILD_SHARED) = yes ]; then \
      $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin'; \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-gcc' '$(PREFIX)/$(TARGET)/lib/libuuid.a'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libuuid.dll.a' '$(PREFIX)/$(TARGET)/lib/libuuid.dll.a'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libuuid.dll' '$(PREFIX)/$(TARGET)/bin/libuuid.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libuuid.dll'; \
    fi

    mkdir '$(1)/.build'
    cd '$(1)' && autoreconf --force -W none

    ### make sure pcre-config of host is used
    $(SED) -i 's,pcre-config,$(PREFIX)/$(TARGET)/bin/pcre-config,g' '$(1)/configure'

    # configure
    cd '$(1)/.build' && '$(1)/configure' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-static \
        --enable-openmp \
        FLTK_CONFIG="$(PREFIX)/bin/$(TARGET)-fltk-config" \
        gl_cv_func_gettimeofday_clobber=no


    ## We want both of these install steps so that we install in the
    ## location set by the configure --prefix option, and the other
    ## in a directory tree that will have just Octave files.
    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install
    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' DESTDIR=$(PREFIX)/../octave install

endef

$(PKG)_BUILD_x86_64-w64-mingw32 =
