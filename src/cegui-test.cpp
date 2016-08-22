/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

/*************************************************
 * CEGUI demo program. This creates an OpenGL window
 * and makes CEGUI draw an "in-game" window into it.
 ************************************************/

#include <CEGUI/CEGUI.h>
#include <CEGUI/RendererModules/OpenGL/GLRenderer.h>
#include <GL/freeglut.h>

// We’re lazy
using namespace CEGUI;

// Prototypes
void main_loop();

// Main program entry point
int main(int argc, char* argv[])
{
  // Initialize OpenGL
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_DEPTH | GLUT_DOUBLE | GLUT_RGBA);
  glutInitWindowSize(640, 480);

  // Create the default GL context to have CEGUI draw upon
  int window_id = glutCreateWindow("Test");

  // Initialize CEGUI (will automatically use the default GL context)
  OpenGLRenderer& renderer = OpenGLRenderer::bootstrapSystem();

  // Tell CEGUI where to find its resources
  DefaultResourceProvider* p_provider = static_cast<DefaultResourceProvider*>(System::getSingleton().getResourceProvider());
  p_provider->setResourceGroupDirectory("schemes", "../share/cegui-0/schemes");
  p_provider->setResourceGroupDirectory("imagesets", "../share/cegui-0/imagesets");
  p_provider->setResourceGroupDirectory("fonts", "../share/cegui-0/fonts");
  p_provider->setResourceGroupDirectory("layouts", "../share/cegui-0/layouts");
  p_provider->setResourceGroupDirectory("looknfeels", "../share/cegui-0/looknfeel");
  p_provider->setResourceGroupDirectory("lua_scripts", "../share/cegui-0/lua_scripts");
  p_provider->setResourceGroupDirectory("schemas", "../share/cegui-0/xml_schemas");
  p_provider->setResourceGroupDirectory("animations", "../share/cegui-0/animations");

  // Map the resource request to our provider
  Scheme::setDefaultResourceGroup("schemes");
  ImageManager::setImagesetDefaultResourceGroup("imagesets");
  Font::setDefaultResourceGroup("fonts");
  WindowManager::setDefaultResourceGroup("layouts");
  WidgetLookManager::setDefaultResourceGroup("looknfeels");
  ScriptModule::setDefaultResourceGroup("lua_scripts");
  AnimationManager::setDefaultResourceGroup("animations");
  XMLParser* p_parser = System::getSingleton().getXMLParser();
  // For the Xerces parser, set the XML schemas resource
  if (p_parser->isPropertyPresent("SchemaDefaultResourceGroup"))
    p_parser->setProperty("SchemaDefaultResourceGroup", "schemas");

  // Configure the default window layouting
  SchemeManager::getSingleton().createFromFile("TaharezLook.scheme");

  // Mouse cursor
  CEGUI::GUIContext& gui_context = CEGUI::System::getSingleton().getDefaultGUIContext();
  gui_context.getMouseCursor().setDefaultImage("TaharezLook/MouseArrow");

  // Create the hypothetical CEGUI root window
  Window* p_root_window = WindowManager::getSingleton().createWindow("DefaultWindow", "root");
  gui_context.setRootWindow(p_root_window);

  // Create an actual framed window we can look onto
  FrameWindow* p_frame_window = static_cast<FrameWindow*>(WindowManager::getSingleton().createWindow("TaharezLook/FrameWindow", "testWindow"));
  p_root_window->addChild(p_frame_window);
  p_frame_window->setPosition(UVector2(UDim(0.25f, 0), UDim(0.25f, 0)));
  p_frame_window->setSize(USize(UDim(0.5f, 0), UDim(0.5f, 0)));
  p_frame_window->setText("Hello World!");

  // Enter main loop
  main_loop();

  // Clean up OpenGL
  glutDestroyWindow(window_id);
}

/* Main loop for processing events, etc. For a real application,
 * you definitely want to replace while(true) with checking a
 * proper termination condition. Note all drawing operations take
 * place on an invisible auxiliary buffer until you call glutSwapBuffers(),
 * which paints the entire auxiliary buffer onto the screen.
 */
void main_loop()
{
  while(true) {
    glutMainLoopEvent(); // Process events
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); // Clear the window background to a single color
    glFlush();
    CEGUI::System::getSingleton().renderAllGUIContexts(); // Tell CEGUI to render all its stuff
    glutSwapBuffers(); // Put the auxiliary rendering buffer onto the screen and make the screen the new auxiliary buffer.
  }
}
