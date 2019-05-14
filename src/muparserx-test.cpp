/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 *
 * based on:
 * https://beltoforion.de/article.php?a=muparserx&hl=en&p=using&s=idInclude#idEval
 */

#include "mpParser.h"

using namespace mup;

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    // Create the parser instance
    ParserX  p;

    // Create an array of mixed type
    Value arr(3, 0);
    arr.At(0) = 2.0;
    arr.At(1) = "this is a string";

    // Create some basic values
    Value cVal(cmplx_type(1, 1));
    Value sVal("Hello World");
    Value fVal(1.1);

    // Now add the variable to muParser
    p.DefineVar("va", Variable(&arr));
    p.DefineVar("a",  Variable(&cVal));
    p.DefineVar("b",  Variable(&sVal));
    p.DefineVar("c",  Variable(&fVal));

    p.SetExpr("va[0]+a*strlen(b)-c");
    for (int i=0; i<10; ++i)
    {
      // evaluate the expression and change the value of
      // the variable c in each turn
      cVal = 1.1 * i;
      Value result = p.Eval();

      // print the result
      console() << result << "\n";
    }
}
