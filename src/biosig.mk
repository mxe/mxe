# This file is part of MXE.
# See index.html for further information.

PKG             := biosig
$(PKG)_WEBSITE  := http://biosig.sf.net/
$(PKG)_DESCR    := Biosig
$(PKG)_VERSION  := 1.8.6
$(PKG)_CHECKSUM := adf1a11260c23c2bf3e6cf89f0344d87ac4e2cc96af931a9670cc87425cd675d
$(PKG)_SUBDIR   := biosig4c++-$($(PKG)_VERSION)
$(PKG)_FILE     := biosig4c++-$($(PKG)_VERSION).src.tar.gz
$(PKG)_URL      := https://sourceforge.net/projects/biosig/files/BioSig%20for%20C_C%2B%2B/src/$($(PKG)_FILE)/download
$(PKG)_DEPS     := gcc libbiosig

define $(PKG)_UPDATE
#    wget -q -O- 'http://biosig.sourceforge.net/download.html' | \
#    $(SED) -n 's_.*>libbiosig, version \([0-9]\.[0-9]\.[0-9]\).*tar.gz_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD_PRE

    # make sure NDEBUG is defined
    $(SED) -i '/NDEBUG/ s|#||g' '$(1)'/Makefile

    #$(SED) -i 's| -fstack-protector | |g' '$(1)'/Makefile
    #$(SED) -i 's| -D_FORTIFY_SOURCE=2 | |g' '$(1)'/Makefile
    #$(SED) -i 's| -lssp | |g' '$(1)'/Makefile

    TARGET='$(TARGET)' $(MAKE) -C '$(1)' clean
    TARGET='$(TARGET)' $(MAKE) -C '$(1)' -j '$(JOBS)' tools

endef

define $(PKG)_BUILD_POST

    TARGET='$(TARGET)' $(MAKE) -C '$(1)' -j '$(JOBS)' install_tools

    mkdir -p $(PREFIX)/release/$(TARGET)/bin/
    -cp $(PREFIX)/$(TARGET)/bin/save2gdf.exe $(PREFIX)/release/$(TARGET)/bin/

    mkdir -p $(PREFIX)/release/matlab/
    -cp $(1)/mex/mex* $(PREFIX)/release/matlab/

    cd '$(1)/win32' && zip $(PREFIX)/$($(PKG)_SUBDIR).$(TARGET).zip *.bat README

endef


define $(PKG)_BUILD_i686-pc-mingw32
	$($(PKG)_BUILD_PRE)
	#HOME=/home/as TARGET=$(TARGET) $(MAKE) -C '$(1)' mexw32
	$($(PKG)_BUILD_POST)
endef

define $(PKG)_BUILD_i686-w64-mingw32
	$($(PKG)_BUILD_PRE)
	#TARGET=$(TARGET) $(MAKE) -C '$(1)' tools
	$($(PKG)_BUILD_POST)
endef

define $(PKG)_BUILD_x86_64-w64-mingw32
	$($(PKG)_BUILD_PRE)
	#TARGET=$(TARGET) $(MAKE) -C '$(1)' tools
	$($(PKG)_BUILD_POST)
endef

