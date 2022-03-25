/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module melodia.gui.buttons;

import atelier;

final class ConfirmationButton: Button {
    private {
        Label _label;
    }

    this(string txt) {
        _label = new Label(txt);
        _label.setAlign(GuiAlignX.center, GuiAlignY.center);
		size = _label.size;
        appendChild(_label);
    }

    override void update(float deltaTime) {
		super.update(deltaTime);
	}

    override void draw() {
        _label.color = Color(20, 20, 20);
        if(isLocked) {
            drawFilledRect(origin, size, Color(204, 204, 204));
            drawRect(origin, size, Color(173, 173, 173));
            _label.color = Color(140, 140, 140);
        }
		else if(isClicked) {
            drawFilledRect(origin, size, Color(204, 228, 247));
            drawRect(origin, size, Color(0, 84, 153));
        }
        else if(isHovered) {
            drawFilledRect(origin, size, Color(229, 241, 251));
            drawRect(origin, size, Color(0, 120, 215));
        }
        else {
            drawFilledRect(origin, size, Color(225, 225, 225));
            drawRect(origin, size, Color(173, 173, 173));
        }
		_label.draw();
	}
}

final class DirButton: Button {
    private {
        Label _label;
    }

    this(string txt, Color color) {
        _label = new Label(txt);
        _label.color = color;
        _label.setAlign(GuiAlignX.center, GuiAlignY.center);
		size = _label.size;
        appendChild(_label);
    }

    override void update(float deltaTime) {
		super.update(deltaTime);
	}

    override void draw() {
		if(isClicked) {
            drawFilledRect(origin, size, Color(204, 228, 247));
        }
        else if(isHovered) {
            drawFilledRect(origin, size, Color(229, 241, 251));
        }
        else {
            drawFilledRect(origin, size, Color.white);
        }
		_label.draw();
	}
}

final class ExitButton: Button {
    private {
        Sprite _crossSprite;
    }

    this() {
        _crossSprite = fetch!Sprite("exit");
		size = _crossSprite.size + Vec2f(5f, 5f);
    }

    override void update(float deltaTime) {
		super.update(deltaTime);
	}

    override void draw() {
		if(isClicked) {
            drawFilledRect(origin, size, Color(204, 228, 247));
            drawRect(origin, size, Color(0, 84, 153));
        }
        else if(isHovered) {
            drawFilledRect(origin, size, Color(229, 241, 251));
            drawRect(origin, size, Color(0, 120, 215));
        }
        else {
            drawFilledRect(origin, size, Color(225, 225, 225));
            drawRect(origin, size, Color(173, 173, 173));
        }
		_crossSprite.draw(center);
	}
}
