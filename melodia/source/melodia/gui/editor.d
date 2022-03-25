/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module melodia.gui.editor;

import std.path, std.string;
import atelier;
import melodia.core, melodia.handler;
import melodia.gui.menubar, melodia.gui.viewer, melodia.gui.tabslist;

/// Fenêtre principale
final class Editor : GuiElement {
    private {
        MenuBar _menuBar;
        Viewer _viewer;
        TabsList _tabsList;

    }

    /// Ctor
    this() {
        size(getWindowSize());
        initializeScript();
        loadConfig();

        _menuBar = new MenuBar(this);
        appendChild(_menuBar);

        _viewer = new Viewer(this);
        appendChild(_viewer);

        _tabsList = new TabsList;
        _tabsList.setCallback(this, "tabslist");
        appendChild(_tabsList);
    }

    override void update(float deltaTime) {
        updateInputs(deltaTime);
        runScript();
    }

    override void onCallback(string id) {
        switch (id) {
        default:
            break;
        }
    }

    override void draw() {

    }

    override void onEvent(Event event) {
        super.onEvent(event);

        switch (event.type) with (Event.Type) {
        case resize:
            size(cast(Vec2f) event.window.size);
            break;
        case dropFile:
            break;
        default:
            break;
        }
    }

    void create() {
        createTab();
        _tabsList.addTab();
    }

    void settings() {
        /// @TODO: settings
    }

    void open() {
        /// @TODO: open
    }

    void openLocaleSettings() {
        /// @TODO: openLocaleSettings
    }

    // Save an already saved project.
    void save() {
        /// @TODO: save
    }

    /// Select a new save file and save the project.
    void saveAs() {
        /// @TODO: saveAs
    }

    void close() {
        /// @TODO: close
    }

    void quit() {
        /// @TODO: quit
    }

    void flipH() {
        /// @TODO: flipH
    }

    void flipV() {
        /// @TODO: flipV
    }

    void cancelChange() {
        /// @TODO: cancelChange
    }

    void restoreChange() {
        /// @TODO: restoreChange
    }

    void updateEntity() {
        /// @TODO: updateEntity
    }

    void editEntity(Entity entity) {
        /// @TODO: editEntity
    }
}
