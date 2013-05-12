/*
 * This file is part of MXE.
 * See index.html for further information.
 */

/*************************************************
 * CEGUI demo program. This creates an OpenGL window
 * and makes CEGUI draw an "in-game" window into it.
 ************************************************/

#include <GL/freeglut.h>
#include <CEGUI/CEGUI.h>
#include <CEGUI/RendererModules/OpenGL/CEGUIOpenGLRenderer.h>

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
  p_provider->setResourceGroupDirectory("schemes", "../share/CEGUI/schemes");
  p_provider->setResourceGroupDirectory("imagesets", "../share/CEGUI/imagesets");
  p_provider->setResourceGroupDirectory("fonts", "../share/CEGUI/fonts");
  p_provider->setResourceGroupDirectory("layouts", "../share/CEGUI/layouts");
  p_provider->setResourceGroupDirectory("looknfeels", "../share/CEGUI/looknfeel");
  p_provider->setResourceGroupDirectory("lua_scripts", "../share/CEGUI/lua_scripts");
  p_provider->setResourceGroupDirectory("schemas", "../share/CEGUI/xml_schemas");
  p_provider->setResourceGroupDirectory("animations", "../share/CEGUI/animations");

  // Map the resource request to our provider
  Imageset::setDefaultResourceGroup("imagesets");
  Font::setDefaultResourceGroup("fonts");
  Scheme::setDefaultResourceGroup("schemes");
  WidgetLookManager::setDefaultResourceGroup("looknfeels");
  WindowManager::setDefaultResourceGroup("layouts");
  ScriptModule::setDefaultResourceGroup("lua_scripts");
  AnimationManager::setDefaultResourceGroup("animations");
  XMLParser* p_parser = System::getSingleton().getXMLParser();
  // For the Xerces parser, set the XML schemas resource
  if (p_parser->isPropertyPresent("SchemaDefaultResourceGroup"))
    p_parser->setProperty("SchemaDefaultResourceGroup", "schemas");

  // Configure the default window layouting
  SchemeManager::getSingleton().create("TaharezLook.scheme");
  System::getSingleton().setDefaultMouseCursor("TaharezLook", "MouseArrow");

  // Create the hypothetical CEGUI root window
  Window* p_root_window = WindowManager::getSingleton().createWindow("DefaultWindow", "root");
  System::getSingleton().setGUISheet(p_root_window);

  // Create an actual framed window we can look onto
  FrameWindow* p_frame_window = static_cast<FrameWindow*>(WindowManager::getSingleton().createWindow("TaharezLook/FrameWindow", "testWindow"));
  p_root_window->addChildWindow(p_frame_window);
  p_frame_window->setPosition(UVector2(UDim(0.25f, 0), UDim(0.25f, 0)));
  p_frame_window->setSize(UVector2(UDim(0.5f, 0), UDim(0.5f, 0)));
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
    System::getSingleton().renderGUI(); // Tell CEGUI to render all its stuff
    glutSwapBuffers(); // Put the auxiliary rendering buffer onto the screen and make the screen the new auxiliary buffer.
  }
}
