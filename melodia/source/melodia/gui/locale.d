/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module melodia.gui.locale;

import std.path, std.file, std.string, std.exception;
import atelier;
import melodia.core;
import melodia.gui.buttons;

final class SelectLocaleModal: GuiElement {
	private {
        SelectLocaleGui _localeSelector;
	}

	this() {
		setAlign(GuiAlignX.center, GuiAlignY.center);
        size(Vec2f(250f, 150f));
        isMovable(true);

		{ //Port
			_localeSelector = new SelectLocaleGui;
			_localeSelector.setAlign(GuiAlignX.center, GuiAlignY.center);
			appendChild(_localeSelector);
		}

		{ //Title
            auto title = new Label(getLocalizedText("select_language") ~ ":");
            title.color = Color(20, 20, 20);
            title.setAlign(GuiAlignX.left, GuiAlignY.top);
            title.position = Vec2f(20f, 10f);
            appendChild(title);
        }

		{ //Close
            auto closeBtn = new ConfirmationButton(getLocalizedText("close"));
            closeBtn.setAlign(GuiAlignX.right, GuiAlignY.bottom);
            closeBtn.position = Vec2f(10f, 10f);
            closeBtn.size = Vec2f(70f, 20f);
            closeBtn.setCallback(this, "close");
            appendChild(closeBtn);
        }

        { //Exit
            auto exitBtn = new ExitButton;
            exitBtn.setAlign(GuiAlignX.right, GuiAlignY.top);
            exitBtn.position = Vec2f(10f, 10f);
            exitBtn.setCallback(this, "close");
            appendChild(exitBtn);
        }

		GuiState hiddenState = {
            offset: Vec2f(0f, -50f),
            alpha: 0f
        };
        addState("hidden", hiddenState);

        GuiState defaultState = {
            time: .5f,
            easing: getEasingFunction(Ease.sineOut)
        };
        addState("default", defaultState);

        setState("hidden");
        doTransitionState("default");
	}

	override void onCallback(string id) {
		switch(id) {
		case "close":
            stopModal();
            sendCustomEvent("locale");
            break;
        default:
            break;
        }
	}

    override void update(float deltaTime) {
        if(getButtonDown(KeyButton.escape) || getButtonDown(KeyButton.enter) || getButtonDown(KeyButton.enter2))
            onCallback("close");
    }

	override void draw() {
        drawFilledRect(origin, size, Color(240, 240, 240));
    }

    override void drawOverlay() {
        drawRect(origin, size, Color(20, 20, 20));
    }
}

private final class SelectLocaleGui: DropDownList {
	private {
		string[] _locales;
	}

	this() {
		super(Vec2f(200f, 25f));
		setCallback(this, "select");
		reload();
	}

    override void onCallback(string id) {
        super.onCallback(id);
        if(id == "select") {
            setLocale(_locales[selected()]);
        }
    }

	private void reload() {
		removeChildren();
        _locales.length = 0uL;
        
        auto path = buildNormalizedPath(getBasePath(), "locale");
        enforce(exists(path), "Missing locale folder");
        foreach(file; dirEntries(path, SpanMode.shallow)) {
            const string filePath = absolutePath(buildNormalizedPath(file));
            if(extension(filePath).toLower() != ".json")
                continue;
            JSONValue json = parseJSON(readText(filePath));
            _locales ~= filePath;
            add(getJsonStr(json, "locale", baseName(filePath)));
        }

        for(size_t i = 0u; i < _locales.length; ++ i) {
            if(_locales[i] == getLocale()) {
                selected(cast(uint) i);
                break;
            }
        }
	}
}