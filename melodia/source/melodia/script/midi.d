module melodia.script.midi;

import grimoire, minuit;
import melodia.midi;

package void loadMelodiaMidiLibrary(GrLibrary library) {
    
    library.addPrimitive(&_note, "note", [grInt, grInt, grInt]);
}

private void _note(GrCall call) {
    MnOutput device = getMidiOut();
    device.send(cast(ubyte)(0x90 | call.getInt(0)), cast(ubyte) call.getInt(1),
            cast(ubyte) call.getInt(2));
}
