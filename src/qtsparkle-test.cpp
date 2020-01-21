/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <qtsparkle-qt5/Updater>
#include <QWidget>
#include <QUrl>

int main()
{
    QWidget w;
    qtsparkle::Updater* updater = new qtsparkle::Updater(
        QUrl("https://www.example.com/sparkle.xml"), &w);
    updater->SetVersion("1.0");

    return 0;
}
