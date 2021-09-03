/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module melodia.midi.state;

private {
    shared float[16] _pitchBendStates;
}

void initializeMidiState() {
    for(int i; i < 16; ++ i) {
        _pitchBendStates[i] = 0f;
    }
}

void setPitchBend(ubyte chan, int value) {
    _pitchBendStates[chan] = ((cast(float) value) - 8192f) / 8192f;
}

float getPitchBend(ubyte chan) {
    return _pitchBendStates[chan];
}