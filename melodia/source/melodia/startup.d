/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module melodia.startup;

import std.stdio, std.conv, std.file, std.path, std.string;
import atelier, grimoire, minuit;
import melodia.constants, melodia.config, melodia.loader, melodia.gui, melodia.midi;

private {
	enum _version = "0.0.1";
	string _lockFileName = ".lock";
	string _msgFileName = ".melodia";
	string _startingFilePath;
	File _lockFile;
	bool _isMainApplication;
	Window _window;
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
	_lockFileName = buildNormalizedPath(getBasePath(), _lockFileName);
	_msgFileName = buildNormalizedPath(getBasePath(), _msgFileName);
	if (!exists(_lockFileName) || isDevMode()) {
		// Si le fichier existe, c'est que Melodia est déjà lancé... ou qu'il a planté, qui sait ?
		_isMainApplication = true;
	}
	if (_isMainApplication) {
		if (!isDevMode()) {
			_lockFile = File(_lockFileName, "w");
			_lockFile.lock();
		}

		enableAudio(false);
		initializeMidiDevices();
		createApplication(Vec2i(WINDOW_WIDTH, WINDOW_HEIGHT), "Studio Melodia");

		setWindowResizable(false);
		setWindowClearColor(Color.white);

		const string iconPath = buildNormalizedPath(getBasePath(), "img", "icon.png");
		if (exists(iconPath))
			setWindowIcon(iconPath);

		if (!processArguments(args)) {
			closeLock();
			return;
		}
		loadResources();
		removeRoots();
		_window = new Window;
		appendRoot(_window);

		scope (exit) {
			//We need to clean up the remaining threads.
			closeLock();
			stopMidiClock();
			closeMidiDevices();
		}
		runApplication();
		destroyApplication();
	}
	else if (processArguments(args)) {
		if (_startingFilePath.length)
			std.file.write(_msgFileName, _startingFilePath);
	}
}

private void closeLock() {
	if (!_isMainApplication)
		return;
	if (!isDevMode()) {
		if (!exists(_lockFileName))
			return;
		_lockFile.close();
		std.file.remove(_lockFileName);
	}
}

string receiveFilePath() {
	if (!exists(_msgFileName) || isDir(_msgFileName))
		return "";
	string filePath;
	try {
		filePath = readText(_msgFileName);
		std.file.remove(_msgFileName);
	}
	catch (Exception e) {
	}
	if (!exists(filePath) || isDir(filePath))
		return "";
	const string ext = extension(filePath).toLower;
	if (ext != ".gr" && ext != ".grimoire" && ext != ".grb")
		return "";
	return filePath;
}
