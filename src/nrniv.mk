# This file is part of MXE.
# See index.html for further information.

PKG             := nrniv
$(PKG)_IGNORE   := 
$(PKG)_CHECKSUM := 162d69bf527b32cbad445302449b723295617775
$(PKG)_SUBDIR   := iv-17
$(PKG)_FILE     := iv-17.tar.gz
$(PKG)_URL      := http://www.neuron.yale.edu/ftp/neuron/versions/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc 

define $(PKG)_UPDATE
    wget -q -O- 'http://www.neuron.yale.edu/neuron/download/getstd' | \
    $(SED) -n 's_.*>[0-9]\./iv-\([0-9\.]\)*\.tar.gz">_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD
	
	## http://stackoverflow.com/questions/5212454/allegro-question-how-can-i-get-rid-of-the-cmd-window
	## ‐Wl,‐‐subsystem,windows

    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --enable-static \

    $(MAKE) -C '$(1)' 
    $(MAKE) -C '$(1)' install 


endef

