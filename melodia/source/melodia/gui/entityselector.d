module melodia.gui.entityselector;

import std.conv : to;
import std.algorithm : min, max;
import atelier;
import melodia.core;

final class EntitySelector : GuiElement {
    private {
        InputField _searchField;
        VList _list;
        VContainer _container;
        string[] _elements;
        string _value;
        Vec2i _targetPosition;
        bool _isValid = true;
    }

    @property {
        bool isValid() const {
            return _isValid;
        }

        string value() const {
            return _value;
        }

        string value(string value_) {
            return _value = value_;
        }

        Vec2i targetPosition() const {
            return _targetPosition;
        }
    }

    this(Vec2i targetPosition_) {
        _targetPosition = targetPosition_;
        setInitFlags(Init.movable);
        size(Vec2f(250f, 30f));
        setAlign(GuiAlignX.center, GuiAlignY.center);

        _searchField = new InputField(Vec2f(200f, 25f));
        _list = new VList(Vec2f(200f, 300f));

        _searchField.hasFocus = true;
        _searchField.setCallback(this, "input");

        auto label = new Label("Ajouter une entité");
        label.position = Vec2f(0f, 5f);
        label.setAlign(GuiAlignX.center, GuiAlignY.top);
        appendChild(label);

        _container = new VContainer;
        _container.position = Vec2f(0f, 20f);
        _container.spacing = Vec2f(0f, 5f);
        _container.setAlign(GuiAlignX.center, GuiAlignY.top);
        appendChild(_container);
        _container.appendChild(_searchField);
        _container.appendChild(_list);

        foreach (tuple; fetchAllTuples!Entity()) {
            add(tuple[1]);
        }

        setup();
    }

    private void setValue(string value_) {
        _value = value_;
        onCallback("apply");
    }

    void add(string msg) {
        _elements ~= msg;
    }

    private void setup() {
        _searchField.text = "";
        _list.removeChildren();
        foreach (key; _elements) {
            auto gui = new EntityElement(key, this);
            _list.appendChild(gui);
            _list.size = Vec2f(200f, min(10f, _list.childCount) * 25f);
        }
        setSelectedName(_value);
    }

    private void filter() {
        import std.typecons : No;
        import std.string : indexOf, toLower;

        string text = toLower(_searchField.text);

        if (text.length == 0u) {
            setup();
            return;
        }

        _list.removeChildren();
        foreach (key; _elements) {
            if (toLower(key).indexOf(text, No.caseSentitive) == -1)
                continue;
            auto gui = new EntityElement(key, this);
            _list.appendChild(gui);
            _list.size = Vec2f(200f, min(10f, _list.childCount) * 25f);
        }
        setSelectedName(_value);
    }

    override void onCallback(string id) {
        switch (id) {
        case "input":
            filter();
            break;
        case "apply":
            triggerCallback();
            break;
        case "cancel":
            _isValid = false;
            removeSelf();
            break;
        default:
            break;
        }
    }

    override void update(float deltaTime) {
        size(_container.size + Vec2f(20f, 30f));

        if (getButtonDown(KeyButton.enter))
            onCallback("apply");
        else if (getButtonDown(KeyButton.escape))
            onCallback("cancel");
    }

    override void draw() {
        drawFilledRect(origin, size, Color.fromHex(0x212121));
    }

    private void setSelectedName(string name) {
        auto list = cast(EntityElement[]) _list.children;
        int i;
        foreach (sub; list) {
            if (sub._label.text == name) {
                _list.selected = i;
                return;
            }
            i++;
        }
    }
}

private class EntityElement : Button {
    private {
        Label _label;
        EntitySelector _selector;
    }

    this(string title, EntitySelector selector) {
        _selector = selector;
        size(Vec2f(200f, 25f));
        _label = new Label(title);
        _label.setAlign(GuiAlignX.center, GuiAlignY.center);
        appendChild(_label);
    }

    override void onSubmit() {
        super.onSubmit();
        _selector.setValue(_label.text);
    }

    override void draw() {
        if (isSelected)
            drawFilledRect(origin, size, Color.fromHex(0x5c5c5c));
        else
            drawFilledRect(origin, size, isHovered ? Color.fromHex(0x494949) : Color.fromHex(0x424242));
    }
}
