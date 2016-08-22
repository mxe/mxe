/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <QString>

#include <Qsci/qsciscintilla.h>

int main(int, char **)
{
    QsciScintilla *scintilla = new QsciScintilla();
    scintilla->setText("Test Text");
    return QString("Test Text").compare(scintilla->text()) != 0;
}
