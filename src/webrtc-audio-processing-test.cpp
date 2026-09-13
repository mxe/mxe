/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 *
 * Builds an audio processing module with AEC3 switched on and runs one 10 ms
 * frame through both directions - the whole reason the package exists. Only
 * linked here, not run: MXE has no exe wrapper.
 */

#include <api/scoped_refptr.h>
#include <modules/audio_processing/include/audio_processing.h>

#include <cstdint>
#include <cstdio>

int main()
{
    webrtc::AudioProcessing::Config config;

    config.echo_canceller.enabled = true;
    config.echo_canceller.mobile_mode = false;
    config.high_pass_filter.enabled = true;
    config.noise_suppression.enabled = true;

    rtc::scoped_refptr<webrtc::AudioProcessing> apm(
        webrtc::AudioProcessingBuilder().Create());

    if (!apm) {
        printf("could not create the audio processing module\n");
        return 1;
    }

    apm->ApplyConfig(config);

    const webrtc::StreamConfig stream(16000, 1);
    int16_t frame[160] = { 0 };

    if (apm->ProcessReverseStream(frame, stream, stream, frame) !=
        webrtc::AudioProcessing::kNoError) {
        printf("ProcessReverseStream failed\n");
        return 1;
    }

    if (apm->ProcessStream(frame, stream, stream, frame) !=
        webrtc::AudioProcessing::kNoError) {
        printf("ProcessStream failed\n");
        return 1;
    }

    return 0;
}
