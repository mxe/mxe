#include <libircclient/libircclient.h>

int
main()
{
	irc_callbacks_t callbacks;
	memset(&callbacks, 0, sizeof(callbacks));

	irc_create_session(&callbacks);
	return 0;
}
