// This file is part of MXE.
// See index.html for further information.

#include <QCoreApplication>
#include <quazip/JlCompress.h>

int main(int argc, char *argv[]){
    QCoreApplication a(argc, argv);
    printf ("%s\n", qPrintable(a.applicationFilePath()));
    JlCompress::compressFile("quatest.zip", a.applicationFilePath());
}
