module melodia.script.midi;

import std.conv : to;
import grimoire, minuit;
import melodia.midi;

package void loadMelodiaMidiLibrary(GrLibrary library) {
    int scale = 0, octave = 0;
    string[] latinNotation = [
        "do", "doD", "ré", "réD", "mi", "fa", "faD", "sol", "solD", "la", "laD",
        "si"
    ];
    string[] abcNotation = [
        "c", "cS", "d", "dD", "e", "f", "fD", "g", "gD", "a", "aD", "b"
    ];
    for (int note; note <= 127; ++note) {
        library.addVariable(latinNotation[scale] ~ to!string(octave), grInt, note, true);
        library.addVariable(abcNotation[scale] ~ to!string(octave), grInt, note, true);
        scale++;
        if (scale >= 12) {
            scale = 0;
            octave++;
        }
    }
    library.addFunction(&_note, "note", [grInt, grInt, grInt]);
    library.addFunction(&_noteDuration, "note", [grInt, grInt, grInt, grInt]);
    library.addFunction(&_stop, "stop", [grInt, grInt]);
}

private void _note(GrCall call) {
    MnOutput device = getMidiOut();
    device.send(cast(ubyte)(0x90 | call.getInt(0)), cast(ubyte) call.getInt(1),
            cast(ubyte) call.getInt(2));
}

private void _noteDuration(GrCall call) {
    MnOutput device = getMidiOut();
    device.send(cast(ubyte)(0x90 | call.getInt(0)), cast(ubyte) call.getInt(1),
            cast(ubyte) call.getInt(2));
}

private void _stop(GrCall call) {
    MnOutput device = getMidiOut();
    device.send(cast(ubyte)(0x80 | call.getInt(0)), cast(ubyte) call.getInt(1));
}
