/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 *
 * from: https://github.com/mxe/mxe/issues/1868
 */


#include <QApplication>

#include <QtWebKitWidgets>

int main(int argc, char **argv){

  QApplication app(argc, argv);

  QWebView *view = new QWebView();
  view->load(QUrl("https://google.com/"));
  view->show();

  app.exec();
}
