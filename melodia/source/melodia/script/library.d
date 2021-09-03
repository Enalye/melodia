/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module melodia.script.library;

import grimoire;
import melodia.script.midi;

/// Load all the functions and types of Melodia
GrLibrary loadMelodiaLibrary() {
    GrLibrary library = new GrLibrary;
    loadMelodiaMidiLibrary(library);
    return library;
}
