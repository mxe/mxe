/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <libspectre/spectre.h>

int main(int argc, char *argv[])
{
    SpectreDocument *document;
    SpectreRenderContext *rc;

    (void)argc;
    (void)argv;

    document = spectre_document_new();
    rc = spectre_render_context_new();

    spectre_document_free(document);
    spectre_render_context_free(rc);

    return 0;
}
