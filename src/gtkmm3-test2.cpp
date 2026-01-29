/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

// test program for OpenGL functionality in gtkmm3
// displays a colored triangle over a white background

#include <gtkmm.h>
#include <epoxy/gl.h>

class Area : public Gtk::GLArea
{
protected:
  GLuint gl_vertex_array, gl_buffer, gl_program;

  virtual void on_realize();
  virtual bool on_render(const Glib::RefPtr<Gdk::GLContext> &context);
};

void Area::on_realize()
{
  Gtk::GLArea::on_realize();

  // OpenGL context
  make_current();
  throw_if_error();

  // background color
  glClearColor(1.0, 1.0, 1.0, 1.0);

  // build vertex array
  glGenVertexArrays(1, &gl_vertex_array);
  glBindVertexArray(gl_vertex_array);
  glGenBuffers(1, &gl_buffer);
  glBindBuffer(GL_ARRAY_BUFFER, gl_buffer);
  GLdouble vertices[] =
    {
      -0.866, -0.7,
       0.866, -0.7,
       0.0,    0.8,
    };
  GLdouble colors[] =
    {
      1.0, 0.0, 0.0,
      0.0, 1.0, 0.0,
      0.0, 0.0, 1.0,
    };
  glBufferData(GL_ARRAY_BUFFER, sizeof(vertices) + sizeof(colors), NULL,
	       GL_STATIC_DRAW);
  glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(vertices), vertices);
  glBufferSubData(GL_ARRAY_BUFFER, sizeof(vertices), sizeof(colors), colors);

  // vertex attributes
  glEnableVertexAttribArray(0);
  glEnableVertexAttribArray(1);
  glVertexAttribPointer(0, 2, GL_DOUBLE, GL_FALSE, 0, (void *) 0);
  glVertexAttribPointer(1, 3, GL_DOUBLE, GL_FALSE, 0,
			(void *) sizeof(vertices));

  // free resources
  glBindVertexArray(0);
  glDeleteBuffers(1, &gl_buffer);

  // build vertex shader
  GLuint vertex_shader;
  vertex_shader = glCreateShader(GL_VERTEX_SHADER);
  const GLchar *vertex_source =
    "#version 330                                       \n"
    "#extension GL_ARB_explicit_attrib_location: enable \n"
    "                                                     "
    "layout(location = 0) in vec2 in_position;            "
    "layout(location = 1) in vec3 in_color;               "
    "                                                     "
    "out vec4 color;                                      "
    "                                                     "
    "void main()                                          "
    "{                                                    "
    "  gl_Position = vec4(in_position, 0.0, 1.0);         "
    "  color = vec4(in_color, 1.0);                       "
    "}                                                    ";
  glShaderSource(vertex_shader, 1, &vertex_source, NULL);
  glCompileShader(vertex_shader);

  // build fragment shader
  GLuint fragment_shader;
  fragment_shader = glCreateShader(GL_FRAGMENT_SHADER);
  const GLchar *fragment_source =
    "#version 330       \n"
    "                     "
    "in vec4 color;       "
    "                     "
    "out vec4 out_color;  "
    "                     "
    "void main()          "
    "{                    "
    "  out_color = color; "
    "}                    ";
  glShaderSource(fragment_shader, 1, &fragment_source, NULL);
  glCompileShader(fragment_shader);

  // build shader program
  gl_program = glCreateProgram();
  glAttachShader(gl_program, fragment_shader);
  glAttachShader(gl_program, vertex_shader);
  glLinkProgram(gl_program);

  // polygon antialiasing
  glEnable(GL_BLEND);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  glEnable(GL_POLYGON_SMOOTH);
}

bool Area::on_render(const Glib::RefPtr<Gdk::GLContext> &context)
{
  // clear screen
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

  // draw
  glUseProgram(gl_program);
  glBindVertexArray(gl_vertex_array);

  glDrawArrays(GL_TRIANGLES, 0, 3);

  // free resources
  glBindVertexArray(0);
  glUseProgram(0);

  // done
  glFlush();

  return true;
}

int main(int argc, char *argv[])
{
  Glib::RefPtr<Gtk::Application> app = Gtk::Application::create(argc, argv);
  Gtk::Window window;
  Area area;

  window.add(area);
  window.show_all();

  return app->run(window);
}
