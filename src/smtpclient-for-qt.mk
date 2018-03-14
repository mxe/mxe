# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := smtpclient-for-qt
$(PKG)_WEBSITE  := https://github.com/bluetiger9/SmtpClient-for-Qt/
$(PKG)_DESCR    := SmtpClient-for-Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := ca43f9d
$(PKG)_CHECKSUM := 60bd3621d5075bbe41afd821a62a99bc1cb8b180a85f23b39f6d44d7926c9df3
$(PKG)_GH_CONF  := bluetiger9/SmtpClient-for-Qt/branches/v1.1
$(PKG)_DEPS     := cc qtbase

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' \
        -after \
        'CONFIG -= dll' \
        'CONFIG += create_prl create_pc' \
        'static:DEFINES += SMTPEXPORTS_H SMTP_EXPORT=' \
        'QMAKE_PKGCONFIG_DESTDIR = pkgconfig' \
        'DESTDIR =' \
        'DLLDESTDIR =' \
        'headers.path = $$$$[QT_INSTALL_HEADERS]' \
        'headers.files = $$$$HEADERS' \
        'win32:dlltarget.path = $$$$[QT_INSTALL_BINS]' \
        'target.path = $$$$[QT_INSTALL_LIBS]' \
        '!static:win32:target.CONFIG = no_dll' \
        'win32:INSTALLS += dlltarget' \
        'INSTALLS += target headers'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
