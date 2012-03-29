/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <wx/wx.h>

class TestApp: public wxApp
{
private:
    bool OnInit()
    {
        wxFrame *frame = new wxFrame(0, -1, _("Hello, World!"));
        frame->Show(true);
        SetTopWindow(frame);
        return true;
    }
};

IMPLEMENT_APP(TestApp)
