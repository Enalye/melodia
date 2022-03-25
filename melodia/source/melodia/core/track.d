/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module melodia.core.track;

enum TRACK_MAX = 64;
enum TRACK_WIDTH = 32;
enum TRACK_HEIGHT = 64;

private {
    Track[TRACK_MAX] _tracks;
    int _currentTrackId = 0;
}

final class Track {
    struct Cell {
        enum Type: ubyte {
            none,
            note
        }

        Type type;
        ubyte[5] args;
    }

    Cell[TRACK_HEIGHT][TRACK_WIDTH] cells;
}

Track getCurrentTrack() {
    return _tracks[_currentTrackId];
}

void initalizeTracks() {
    for (uint t; t < TRACK_MAX; ++t) {
        _tracks[t] = new Track;
    }
}
