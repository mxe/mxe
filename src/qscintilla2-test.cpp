/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <QString>

#include <Qsci/qsciscintilla.h>

int main(int, char **)
{
    QsciScintilla *scintilla = new QsciScintilla();
    scintilla->setText("Test Text");
    return QString("Test Text").compare(scintilla->text()) != 0;
}
