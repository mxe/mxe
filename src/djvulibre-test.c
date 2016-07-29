/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <libdjvu/ddjvuapi.h>

int main(int argc, char *argv[])
{
	ddjvu_context_t *djvu_test;
	(void)argc;

	djvu_test = ddjvu_context_create(argv[0]);
	ddjvu_context_release(djvu_test);

	return 0;
}
