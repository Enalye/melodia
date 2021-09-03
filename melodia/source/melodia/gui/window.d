/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module melodia.gui.window;

import std.path, std.string;
import atelier;
import melodia.startup : receiveFilePath;
import melodia.constants, melodia.handler, melodia.config;

/// Fenêtre principale
final class Window : GuiElement {
    private {

    }

    /// Ctor
    this() {
        size(Vec2f(WINDOW_WIDTH, WINDOW_HEIGHT));
        initializeScript();
        loadConfig();
    }

    override void update(float deltaTime) {
        string receivedFilePath = receiveFilePath();
        if (receivedFilePath.length)
            loadScript(receivedFilePath);
        runScript();
    }

    override void draw() {

    }

    override void onEvent(Event event) {
        super.onEvent(event);

        switch (event.type) with (Event.Type) {
        case dropFile:
            const string ext = extension(event.drop.filePath).toLower;
            if (ext == ".gr" || ext == ".grimoire" || ext == ".grb")
                loadScript(event.drop.filePath);
            break;
        default:
            break;
        }
    }
}
