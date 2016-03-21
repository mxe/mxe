/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <qtsparkle/Updater>
#include <QWidget>
#include <QUrl>

int main()
{
	QWidget w;
	qtsparkle::Updater* updater = new qtsparkle::Updater(
		QUrl("http://www.example.com/sparkle.xml"), &w);
	updater->SetVersion("1.0");

	return 0;
}
