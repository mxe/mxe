/*
 This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <fluidsynth.h>

int main(int argc, char** argv) 
{
    fluid_settings_t* settings;
    fluid_synth_t* synth;
    settings = new_fluid_settings();
    synth = new_fluid_synth(settings);

	/* Do useful things here */

    delete_fluid_synth(synth);
    delete_fluid_settings(settings);

    return 0;
}
