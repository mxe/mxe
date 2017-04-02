/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <QCoreApplication>
#include <QtCrypto>
#include <QDebug>

#include <iostream>

#ifdef QT_STATICPLUGIN
#include "import_plugins.h"
#endif

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    QCA::init();

    QByteArray inputString = "Hello world!";
    if (a.arguments().size() > 1) {
        inputString = a.arguments().at(1).toUtf8();
    }
    std::cout << "input string:\n" << inputString.toStdString() << "\n\n";

    // Calculate hashes of a string with all available hashing algorithms:
    QByteArray outputString;
    for (const QString &hastType : QCA::Hash::supportedTypes()) {
        QCA::Hash hashObject(hastType);
        hashObject.update(inputString);
        outputString = hashObject.final().toByteArray().toHex();

        std::cout << hastType.toStdString() << " hash:\n"
                  << outputString.toStdString() << "\n\n";
    }

    return 0;
}
