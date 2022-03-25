/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module melodia.core.locale;

import std.file;
import atelier;
import melodia.core.config : saveConfig;

private {
    string _localeFilePath;
    string[string] _localizations;
}

string getLocale() {
    return _localeFilePath;
}

void setLocale(string filePath) {
    if (!exists(filePath))
        return;
    _localeFilePath = filePath;

    JSONValue json = parseJSON(readText(_localeFilePath));
    foreach (string key, JSONValue value; json) {
        _localizations[key] = value.str;
    }

    sendCustomEvent("locale");
    saveConfig();
}

string getLocalizedText(string key) {
    auto value = key in _localizations;
    if (value is null)
        return key;
    return *value;
}
