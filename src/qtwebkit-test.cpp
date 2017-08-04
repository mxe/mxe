/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 *
 * from: https://github.com/mxe/mxe/issues/1868
 */


#include <QApplication>

#include <QtWebKitWidgets/QWebView>
#include <QtWebKitWidgets/QWebFrame>

int main(int argc, char **argv){

  QApplication app(argc, argv);

  QWebView *view = new QWebView();
  view->load(QUrl("http://google.com/"));
  view->show();

  app.exec();
}
