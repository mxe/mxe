/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <gtk/gtk.h>
#include <gtk/gtkgl.h>
#include <GL/gl.h>

static gboolean eventExpose(GtkWidget *gl, GdkEventExpose *e, gpointer userData)
{
    GdkGLContext *ctx = gtk_widget_get_gl_context(gl);
    GdkGLDrawable *drawable = gtk_widget_get_gl_drawable(gl);

    (void)e;
    (void)userData;

    gdk_gl_drawable_gl_begin(drawable, ctx);

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    if (!gdk_gl_drawable_is_double_buffered(drawable))
        glFinish();
    else
        gdk_gl_drawable_swap_buffers(drawable);

    gdk_gl_drawable_gl_end(drawable);

    return TRUE;
}

static gboolean eventConfigure(GtkWidget *gl, GdkEventConfigure *e, gpointer userData)
{
    const guint width = gl->allocation.width;
    const guint height = gl->allocation.height;

    (void)e;
    (void)userData;

    glLoadIdentity();
    glViewport(0, 0, width, height);
    glOrtho(-3.5, 3.5, -3.5 * (GLfloat)height / (GLfloat)width,
        3.5 * (GLfloat)height / (GLfloat)width, -3.5, 3.5);

    return TRUE;
}

int main(int argc, char *argv[])
{
    GtkWidget* window;
    GtkWidget* gl;
    GdkGLConfig* glConfig;

    gtk_init(&argc, &argv);
    gtk_gl_init(&argc, &argv);

    window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gl = gtk_drawing_area_new();
    gtk_container_add(GTK_CONTAINER(window), gl);

    gtk_widget_set_events(gl, GDK_EXPOSURE_MASK);

    glConfig = gdk_gl_config_new_by_mode(
        GDK_GL_MODE_RGB |
        GDK_GL_MODE_ALPHA |
        GDK_GL_MODE_DEPTH |
        GDK_GL_MODE_DOUBLE);

    gtk_widget_set_gl_capability(gl, glConfig,
        NULL, TRUE, GDK_GL_RGBA_TYPE);

    g_signal_connect_swapped(
        G_OBJECT(window), "destroy",
        G_CALLBACK(gtk_main_quit), G_OBJECT(window));

    g_signal_connect(
        G_OBJECT(window), "destroy",
        G_CALLBACK(gtk_main_quit), NULL);

    g_signal_connect(gl, "configure-event",
        G_CALLBACK(eventConfigure), NULL);

    g_signal_connect(gl, "expose-event",
        G_CALLBACK(eventExpose), NULL);

    gtk_widget_show_all(window);

    gtk_main();
    return 0;
}
