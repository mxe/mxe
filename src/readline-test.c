/* Simple program to test readline library */
#include <stdio.h>
#include <readline/readline.h>
#include <readline/history.h>
#include <stdlib.h>

int
main(int argc, char **argv)
/***********************************************************
 * Begin execution here.
 */
{
   int rtn = EXIT_FAILURE;

   /*========= initialize GNU readline & history ========*/
   rl_initialize();

   /* enable conditional parsing of ~/.inputrc */
   rl_readline_name= "readline-test";

   using_history();

   /* Limit how many history lines are saved. */
   stifle_history(100);

   /*** read input one line at a time ***/
   printf("LOOK: >> readline library test. Type stuff and press Enter. Press Ctrl-D to exit.\n");
   fflush(stdout);
   for(;;) {
      char *buf= readline("readline> ");
      if(!buf)
         break;
      printf("Received: \"%s\"\n", buf);
      fflush(stdout);
      free(buf);
   }
   /* Normal exit */
   rtn = EXIT_SUCCESS;

 abort:
   return rtn;
}
