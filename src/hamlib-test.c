/*  This file is part of MXE. See LICENSE.md for licensing information.
 *  This is a elementary program calling and testing Hamlib.
 */

#include <stdio.h>
#include <string.h>
#include <hamlib/rig.h>
#include <hamlib/riglist.h>

int main(int argc, char *argv[]) {
    RIG *my_rig;
    char *rig_file, *info_buf, *mm;
    freq_t freq;
    value_t rawstrength, power, strength;
    float s_meter, rig_raw2val();
    int status, retcode, isz;
    unsigned int mwpower;
    rmode_t mode;
    pbwidth_t width;
    rig_model_t myrig_model;
    char portname[64];
    port_t myport;

    strncpy(portname, argv[2], 63);
    portname[63] = '\0';

    if ((strcmp(argv[2], "--help") == 0) || (argc < 2)) {
        printf("use like: ./%s <portname>\n", argv[0]);
        printf("example:  ./%s /dev/ttyS0\n", argv[0]);
        return 0;
    }

    /* Try to detect rig */
    /* may be overridden by backend probe */
    myport.type.rig = RIG_PORT_SERIAL;
    myport.parm.serial.rate = 9600;
    myport.parm.serial.data_bits = 8;
    myport.parm.serial.stop_bits = 1;
    myport.parm.serial.parity = RIG_PARITY_NONE;
    myport.parm.serial.handshake = RIG_HANDSHAKE_NONE;
    strncpy(myport.pathname, portname, FILPATHLEN);

    rig_load_all_backends();
    myrig_model = rig_probe(&myport);
    /* Set verbosity level - errors only */
    rig_set_debug(RIG_DEBUG_ERR);
    /* Instantiate a rig - your rig */
    /* my_rig = rig_init(RIG_MODEL_TT565); */
    my_rig = rig_init(myrig_model);
    /* Set up serial port, baud rate - serial device + baudrate */
    rig_file = "/dev/ttyUSB0";
    strncpy(my_rig->state.rigport.pathname, rig_file, FILPATHLEN - 1);
    my_rig->state.rigport.parm.serial.rate = 57600;
    my_rig->state.rigport.parm.serial.rate = 9600;
    /* Open my rig */
    retcode = rig_open(my_rig);
    printf("retcode of rig_open = %d \n", retcode);
    /* Give me ID info, e.g., firmware version. */
    info_buf = (char *)rig_get_info(my_rig);
    printf("Rig_info: '%s'\n", info_buf);

    /* Note: As a general practice, we should check to see if a given
     * function is within the rig's capabilities before calling it, but
     * we are simplifying here. Also, we should check each call's returned
     * status in case of error. (That's an inelegant way to catch an unsupported
     * operation.)
     */

    /* Main VFO frequency */
    status = rig_get_freq(my_rig, RIG_VFO_CURR, &freq);
    printf("status of rig_get_freq = %d \n", status);
    printf("VFO freq. = %.1f Hz\n", freq);
    /* Current mode */
    status = rig_get_mode(my_rig, RIG_VFO_CURR, &mode, &width);
    printf("status of rig_get_mode = %d \n", status);
    switch(mode) {
        case RIG_MODE_USB: mm = "USB"; break;
        case RIG_MODE_LSB: mm = "LSB"; break;
        case RIG_MODE_CW:  mm = "CW"; break;
        case RIG_MODE_CWR: mm = "CWR"; break;
        case RIG_MODE_AM:  mm = "AM"; break;
        case RIG_MODE_FM:  mm = "FM"; break;
        case RIG_MODE_WFM: mm = "WFM"; break;
        case RIG_MODE_RTTY:mm = "RTTY"; break;
        default: mm = "unrecognized"; break; /* there are more possibilities! */
        }
    printf("Current mode = 0x%X = %s, width = %d\n", mode, mm, (int) width);
    /* rig power output */
    status = rig_get_level(my_rig, RIG_VFO_CURR, RIG_LEVEL_RFPOWER, &power);
    printf("RF Power relative setting = %.3f (0.0 - 1.0)\n", power.f);
    /* Convert power reading to watts */
    status = rig_power2mW(my_rig, &mwpower, power.f, freq, mode);
    printf("RF Power calibrated = %.1f Watts\n", mwpower/1000.);
    /* Raw and calibrated S-meter values */
    status = rig_get_level(my_rig, RIG_VFO_CURR, RIG_LEVEL_RAWSTR, &rawstrength);
    printf("Raw receive strength = %d\n", rawstrength.i);
    isz = my_rig->caps->str_cal.size;
    printf("isz = %d \n", isz);
    s_meter = rig_raw2val(rawstrength.i, &my_rig->caps->str_cal);
    printf("S-meter value = %.2f dB relative to S9\n", s_meter);
    /* now try using RIG_LEVEL_STRENGTH itself */
    status = rig_get_strength(my_rig, RIG_VFO_CURR, &strength);
    printf("status of rig_get_strength = %d \n", status);
    printf("LEVEL_STRENGTH returns %d\n", strength.i);
return 0;
}
