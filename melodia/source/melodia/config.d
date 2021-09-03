/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module melodia.config;

import std.file, std.path;
import atelier, minuit;
import melodia.locale, melodia.midi;

private {
    bool _isConfigFilePathConfigured;
    string _configFilePath = "config.json";
    bool _isDevMode = true;
    string _currentFolder;
}

bool isDevMode() {
    return _isDevMode;
}

string getBasePath() {
    if(_isDevMode) {
        return getcwd();
    }
    else {
        return dirName(thisExePath());
    }
}

void setCurrentFolder(string folder) {
    _currentFolder = folder;
}

string getCurrentFolder() {
    return _currentFolder;
}

/// Load config file
void loadConfig() {
    if(!_isConfigFilePathConfigured) {
        _isConfigFilePathConfigured = true;
        _configFilePath = buildNormalizedPath(getBasePath(), _configFilePath);
    }
    if(!exists(_configFilePath)) {
        saveConfig();
        if(!exists(_configFilePath))
            return;
    }
    JSONValue json = parseJSON(readText(_configFilePath));
    string outputName = getJsonStr(json, "output", "");
    string localePath = buildNormalizedPath(absolutePath(getJsonStr(json, "locale", ""), getBasePath()));
    setCurrentFolder(getJsonStr(json, "folder", ""));
    selectMidiOutDevice(mnFetchOutput(outputName));
    setLocale(localePath);
}

/// Save config file
void saveConfig() {
    JSONValue json;
    auto midiOut = getMidiOut();
    json["output"] = (midiOut && midiOut.port) ? midiOut.port.name : "";
    json["locale"] = (getLocale().length && exists(getLocale())) ?
        relativePath(buildNormalizedPath(getLocale()), getBasePath()) :
        buildNormalizedPath("locale", "en.json");
    json["folder"] = getCurrentFolder();

    std.file.write(_configFilePath, toJSON(json, true));
}