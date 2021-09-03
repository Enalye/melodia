/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module melodia.midi.device;

import minuit;

private {
	MnOutput _midiOut;
}

void initializeMidiDevices() {
	_midiOut = new MnOutput;
}

void closeMidiDevices() {
    if(_midiOut)
        _midiOut.close();
	_midiOut = null;
}

void selectMidiOutDevice(MnOutputPort port) {
    import melodia.config: saveConfig;
    if(!_midiOut)
        return;
    if(!port) {
        _midiOut.close();
        _midiOut.port = null;
        saveConfig();
        return;
    }
    _midiOut.close();
    _midiOut.port = port;
    if(port)
        _midiOut.open(port);
    saveConfig();
}

MnOutput getMidiOut() {
	return _midiOut;
}