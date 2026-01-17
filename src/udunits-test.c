/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include "config.h"

#include "udunits2.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static int exitCode=0;
static ut_system *unitSystem=NULL;


static void
ASSERT_STRING_EQUAL(const char *str1, const char *str2) {
  if (strcmp(str1, str2) != 0) {
    fprintf(stderr, "Failed assertion: %s == %s\n", str1, str2);
    exitCode=1;
  }
}


static void
ASSERT_INT_EQUAL(int int1, int int2) {
  if (int1 != int2) {
    fprintf(stderr, "Failed assertion: %d == %d\n", int1, int2);
    exitCode=1;
  }
}


static void
ASSERT_DOUBLE_EQUAL(double dbl1, double dbl2) {
  if (dbl1 != dbl2) {
    fprintf(stderr, "Failed assertion: %f == %f\n", dbl1, dbl2);
    exitCode=1;
  }
}


static void
test_utGetUnitByName(void)
{
    ut_unit *meter, *celsius, *kilogram, *kelvin, *second, *radian;

    meter = ut_get_unit_by_name(unitSystem, "meter");
    celsius = ut_get_unit_by_name(unitSystem, "celsius");
    kilogram = ut_get_unit_by_name(unitSystem, "kilogram");
    kelvin = ut_get_unit_by_name(unitSystem, "kelvin");
    second = ut_get_unit_by_name(unitSystem, "second");
    radian = ut_get_unit_by_name(unitSystem, "radian");

    ASSERT_STRING_EQUAL(ut_get_name(meter, UT_ASCII), "meter");
    ASSERT_STRING_EQUAL(ut_get_name(celsius, UT_ASCII), "degree_Celsius");
    ASSERT_STRING_EQUAL(ut_get_name(kilogram, UT_ASCII), "kilogram");
    ASSERT_STRING_EQUAL(ut_get_name(kelvin, UT_ASCII), "kelvin");
    ASSERT_STRING_EQUAL(ut_get_name(second, UT_ASCII), "second");
    ASSERT_STRING_EQUAL(ut_get_name(radian, UT_ASCII), "radian");
}


static void
test_utGetUnitBySymbol(void)
{
    ut_unit *kilogram, *meter, *kelvin, *second, *radian, *hertz;

    kilogram = ut_get_unit_by_symbol(unitSystem, "kg");
    meter = ut_get_unit_by_symbol(unitSystem, "m");
    kelvin = ut_get_unit_by_symbol(unitSystem, "K");
    second = ut_get_unit_by_symbol(unitSystem, "s");
    radian = ut_get_unit_by_symbol(unitSystem, "rad");
    hertz = ut_get_unit_by_symbol(unitSystem, "Hz");

    ASSERT_STRING_EQUAL(ut_get_symbol(kilogram, UT_ASCII), "kg");
    ASSERT_STRING_EQUAL(ut_get_symbol(meter, UT_ASCII), "m");
    ASSERT_STRING_EQUAL(ut_get_symbol(kelvin, UT_ASCII), "K");
    ASSERT_STRING_EQUAL(ut_get_symbol(second, UT_ASCII), "s");
    ASSERT_STRING_EQUAL(ut_get_symbol(radian, UT_ASCII), "rad");
    ASSERT_STRING_EQUAL(ut_get_symbol(hertz, UT_ASCII), "Hz");
}


static void
test_ut_decode_time(void)
{
    double      timeval1, timeval2;
    int         year1, month1, day1, hour1, minute1;
    double      second1, resolution1;
    ut_unit     *unit1, *unit2;
    cv_converter *convert12;

    timeval1 = ut_encode_time(2010, 1, 11, 9, 8, 10);
    ut_decode_time(timeval1, &year1, &month1, &day1, &hour1, &minute1,
        &second1, &resolution1);
    ASSERT_INT_EQUAL(year1, 2010);
    ASSERT_INT_EQUAL(month1, 1);
    ASSERT_INT_EQUAL(day1, 11);
    ASSERT_INT_EQUAL(hour1, 9);
    ASSERT_INT_EQUAL(minute1, 8);
    ASSERT_DOUBLE_EQUAL(second1, 10);

    unit1 = ut_parse(unitSystem, "second since 2010-01-11T09:08:10Z", UT_ASCII);
    unit2 = ut_parse(unitSystem, "second since 2001-01-01T00:00:00Z", UT_ASCII);
    convert12 = ut_get_converter(unit1, unit2);
    timeval2 = cv_convert_double(convert12, 0);
    ASSERT_DOUBLE_EQUAL(timeval1, timeval2);

    cv_free(convert12);
    ut_free(unit1);
    ut_free(unit2);
}


int
main(
    const int           argc,
    const char* const*  argv)
{
    const char *xmlPath;

    if (argc > 1) {
      xmlPath = argv[1]
              ? argv[1]
              : getenv("UDUNITS2_XML_PATH");
    }

    ut_set_error_message_handler(ut_ignore);

    unitSystem = ut_read_xml(xmlPath);
    if (unitSystem == NULL) {
      fprintf(stderr, "Failed to open units database.\n");
      fprintf(stderr, "Please provide database path via command argument or UDUNITS2_XML_PATH\n");
      return 2;
    }

    test_utGetUnitByName();
    test_utGetUnitBySymbol();
    test_ut_decode_time();

    ut_free_system(unitSystem);

    return exitCode;
}
