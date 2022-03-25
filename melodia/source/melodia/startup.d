/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module melodia.startup;

import std.stdio, std.conv, std.file, std.path, std.string;
import atelier, grimoire, minuit;
import melodia.core, melodia.loader, melodia.gui, melodia.midi;

private {
    enum _version = "0.0.1";
    string _msgFileName = ".melodia";
    string _startingFilePath;
    Editor _editor;
}

bool processArguments(string[] args) {
    if (args.length == 1)
        return true;
    string arg = args[1];
    if (!arg.length)
        return false;
    switch (arg) {
    case "-v":
    case "--version":
        writeln("Melodia version " ~ _version);
        break;
    case "-h":
    case "--help":
        writeln("Melodia (c) 2021 by Enalye.
Melodia is a free software and comes with ABSOLUTELY NO WARRANTY.

Usage:
 melodia
 melodia <file>
 melodia <option>

Where:
 <file> A midi file path to read

<option>:
 -h or --help		Display this help
 -v or --version 	Display the version number");
        break;
    default:
        _startingFilePath = arg;
        break;
    }
    return true;
}

void setupApplication(string[] args) {
    enableAudio(false);
    initializeMidiDevices();
    createApplication(Vec2i(WINDOW_WIDTH, WINDOW_HEIGHT), "Studio Mélodia");

    setWindowResizable(true);
    setWindowClearColor(Color.black);
    //setDefaultFont(new TrueTypeFont(veraFontData, 24));

    const string iconPath = buildNormalizedPath(getBasePath(), "img", "icon.png");
    if (exists(iconPath))
        setWindowIcon(iconPath);

    loadResources();
    removeRoots();
    _editor = new Editor;
    appendRoot(_editor);

    scope (exit) {
        //We need to clean up the remaining threads.
        stopMidiClock();
        closeMidiDevices();
    }
    runApplication();
    destroyApplication();
}