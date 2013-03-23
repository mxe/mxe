/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <CEGUI/CEGUI.h>
#include <CEGUI/RendererModules/OpenGL/CEGUIOpenGLRenderer.h>

int main(int argc, char* argv[])
{
  CEGUI::OpenGLRenderer& renderer = CEGUI::OpenGLRenderer::bootstrapSystem();
  CEGUI::OpenGLRenderer::destroy(renderer);
}
