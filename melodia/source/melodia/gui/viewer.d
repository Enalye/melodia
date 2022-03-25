module melodia.gui.viewer;

import atelier;
import melodia.core;
import melodia.gui.constants, melodia.gui.editor, melodia.gui.entityselector;

final class Viewer : GuiElement {
    private {
        TabData _currentTabData;

        Vec2i _startCopyPosition, _endCopyPosition, _beginGrabbingPosition;
        bool _isSelecting, _hasCopySelection, _showGrid;

        //Mouse control        
        Vec2f _startMovingCursorPosition, _cursorPosition = Vec2f.zero;
        bool _isGrabbed;
        float _scale = 1f;
        Timer _timer;

        EntitySelector _entitySelector;
        bool _isEntityGrabbed, _isSelectingEntity;
        Entity[] _selectedEntities;
        Vec2i[] _unsnappedEntityPositions;
        Editor _editor;
        Sprite _rectSprite, _markerSprite;
        float _globalAlphaMask = 0f;
    }

    this(Editor editor) {
        _editor = editor;
        position(Vec2f(0f, (barHeight + tabsHeight)));
        size(Vec2f(getWindowWidth(), getWindowHeight() - tabsHeight));
        _timer.mode = Timer.Mode.bounce;
        _timer.start(5f);
        hasCanvas(true);

        _rectSprite = fetch!Sprite("editor.rect");
        _markerSprite = fetch!Sprite("editor.marker");
    }

}