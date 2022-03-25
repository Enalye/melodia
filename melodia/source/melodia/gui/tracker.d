/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module melodia.gui.tracker;

import atelier;
import melodia.core;

import std.stdio;
/+
final class Tracker : GuiElement {
    private {
        Vec2i _cursor, _cameraOffset, _cameraSize;
        Vec2i _digitSize = Vec2i(10, 25);
        Vec2i _opSize = Vec2i(50, 25);
        int _opCursor;
    }

    this() {
        position(Vec2f(10f, 20f));
        size(Vec2f(WINDOW_WIDTH - 10f, WINDOW_HEIGHT - 20f));
        _cameraSize = cast(Vec2i) size() / _digitSize - 1;
        setCanvas(true);
            canvas.position = Vec2f(clamp(_cursor.x * _opSize.x, size.x / 2f, (
                    TRACK_WIDTH * _opSize.x) - size.x / 2f), _cursor.y * _opSize.y);
    }

    override void update(float deltaTime) {
        if (getInputLeft()) {
            if (_cursor.x > 0)
                _cursor.x--;
            else
                _cursor.x = TRACK_WIDTH - 1;

            if (_cursor.x < _cameraOffset.x) {
                _cameraOffset.x = _cursor.x;
            }
            else if (_cursor.x > (_cameraOffset.x + _cameraSize.x)) {
                _cameraOffset.x = _cursor.x - _cameraSize.x;
            }
            canvas.position = Vec2f(clamp(_cursor.x * _opSize.x, size.x / 2f, (
                    TRACK_WIDTH * _opSize.x) - size.x / 2f), canvas.position.y);
        }
        if (getInputRight()) {
            if ((_cursor.x + 1) < TRACK_WIDTH)
                _cursor.x++;
            else
                _cursor.x = 0;

            if (_cursor.x < _cameraOffset.x) {
                _cameraOffset.x = _cursor.x;
            }
            else if (_cursor.x > (_cameraOffset.x + _cameraSize.x)) {
                _cameraOffset.x = _cursor.x - _cameraSize.x;
            }
            canvas.position = Vec2f(clamp(_cursor.x * _opSize.x, size.x / 2f, (
                    TRACK_WIDTH * _opSize.x) - size.x / 2f), canvas.position.y);
        }
        if (getInputUp()) {
            if (_cursor.y > 0)
                _cursor.y--;
            else
                _cursor.y = TRACK_HEIGHT - 1;

            if (_cursor.y < _cameraOffset.y) {
                _cameraOffset.y = _cursor.y;
            }
            else if (_cursor.y > (_cameraOffset.y + _cameraSize.y)) {
                _cameraOffset.y = _cursor.y - _cameraSize.y;
            }
            canvas.position = Vec2f(canvas.position.x, _cursor.y * _opSize.y);
        }
        if (getInputDown()) {
            if ((_cursor.y + 1) < TRACK_HEIGHT)
                _cursor.y++;
            else
                _cursor.y = 0;

            if (_cursor.y < _cameraOffset.y) {
                _cameraOffset.y = _cursor.y;
            }
            else if (_cursor.y > (_cameraOffset.y + _cameraSize.y)) {
                _cameraOffset.y = _cursor.y - _cameraSize.y;
            }
            canvas.position = Vec2f(canvas.position.x, _cursor.y * _opSize.y);
        }
    }

    override void onEvent(Event event) {
        Track track = getCurrentTrack();
        switch (event.type) with (Event.Type) {
        case keyInput:
            if (event.input.text.length == 1) {
                switch (event.input.text[0]) {
                case 'a':
                    track.cells[_cursor.x][_cursor.y].type = Track.Cell.Type.note;
                    break;
                default:
                    break;
                }
            }
            break;
        default:
            break;
        }
    }

    override void draw() {
        Track track = getCurrentTrack();
        drawFilledRect(origin, size, Color.black);

        //if (_cursor.isBetween(_cameraOffset, _cameraOffset + _cameraSize)) {
        {
            Vec2f cursorPos = Vec2f(_cursor.x * _opSize.x, canvas.position.y);
            drawRect(cursorPos, cast(Vec2f) _opSize, Color.fromHex(0xffb545));
            drawFilledRect(cursorPos +
                    Vec2f(
                        _opCursor * _digitSize.x, 0f), cast(Vec2f) _digitSize, Color.fromHex(
                        0xffb545));

        }
        /*drawRect(origin + cast(Vec2f)((_cursor - _cameraOffset) * _opSize), cast(Vec2f) _opSize, Color.fromHex(
                        0xffb545));
            drawFilledRect(origin + cast(Vec2f)((_cursor - _cameraOffset) * _opSize) +
                    Vec2f(
                        _opCursor * _digitSize.x, 0f), cast(Vec2f) _digitSize, Color.fromHex(
                        0xffb545));*/
        //}

        for (int y = 0; y < TRACK_HEIGHT; ++y) {
            for (int x = 0; x < TRACK_WIDTH; ++x) {
                Vec2f pos = Vec2f(x * _opSize.x, y * _opSize.y);
                // Vec2f pos = center + Vec2f(x - _cursor.x, y - _cursor.y) * cast(Vec2f)_opSize;
                Track.Cell cell = track.cells[x][y];
                if (cell.type == Track.Cell.Type.none) {
                    drawText(".", pos, Color.white);
                    //drawFilledRect(origin, size, Color.black);
                }
                else {
                    drawText("a", pos, Color.fromHex(0x72dec2));
                }
            }
        }
    }
}
+/