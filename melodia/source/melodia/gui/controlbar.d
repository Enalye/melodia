module melodia.gui.controlbar;

import atelier;
import melodia.handler;

final class ControlBar : GuiElement {
    private {
        bool _isVisible = true;
    }

    this() {
        size(Vec2f(getWindowWidth(), 50f));
        setAlign(GuiAlignX.center, GuiAlignY.bottom);

        {
            auto hbox = new HContainer;
            hbox.setAlign(GuiAlignX.left, GuiAlignY.bottom);
            hbox.position = Vec2f(48f, 5f);
            hbox.spacing = Vec2f(2f, 0f);
            appendChild(hbox);

            auto playBtn = new PlayButton;
            hbox.appendChild(playBtn);

            auto rewindBtn = new RewindButton;
            hbox.appendChild(rewindBtn);

            auto stopBtn = new StopButton;
            hbox.appendChild(stopBtn);

            auto reloadBtn = new ReloadButton;
            hbox.appendChild(reloadBtn);
        }

        GuiState hiddenState = {
            offset: Vec2f(0f, -50f), time: .25f, easing: getEasingFunction(Ease.quadInOut)
        };
        addState("hidden", hiddenState);

        GuiState shownState = {
            time: .25f, easing: getEasingFunction(Ease.quadInOut)
        };
        addState("shown", shownState);
        setState("shown");
    }

    override void onEvent(Event event) {
        switch (event.type) with (Event.Type) {
        case resize:
            size(Vec2f(event.window.size.x, 50f));
            break;
        case custom:
            if (event.custom.id == "hide") {
                doTransitionState(_isVisible ? "hidden" : "shown");
                _isVisible = !_isVisible;
            }
            break;
        default:
            break;
        }
    }

    override void onCallback(string id) {
        super.onCallback(id);
        switch (id) {
        default:
            break;
        }
    }

    override void draw() {
        drawFilledRect(origin, size, Color(240, 240, 240));
    }
}

final class PlayButton : Button {
    private {
        Sprite _pauseSprite, _playSprite;
    }

    this() {
        _pauseSprite = fetch!Sprite("pause");
        _playSprite = fetch!Sprite("play");

        setAlign(GuiAlignX.left, GuiAlignY.bottom);
        position = Vec2f(4f, 2f);
        size = Vec2f(30f, 30f);
    }

    override void onSubmit() {
        if (getScriptPause())
            setScriptPause(true);
        else
            setScriptPause(false);
    }

    override void update(float deltaTime) {
        super.update(deltaTime);
        if (getButtonDown(KeyButton.space) || getButtonDown(KeyButton.k)
                || getButtonDown(KeyButton.p))
            onSubmit();
    }

    override void draw() {
        if (isClicked) {
            drawFilledRect(origin, size, Color(204, 228, 247));
            drawRect(origin, size, Color(0, 84, 153));
        }
        else if (isHovered) {
            drawFilledRect(origin, size, Color(229, 241, 251));
            drawRect(origin, size, Color(0, 120, 215));
        }
        else {
            drawFilledRect(origin, size, Color(225, 225, 225));
            drawRect(origin, size, Color(173, 173, 173));
        }
        /*if(isMidiPlaying() && isMidiClockRunning())
            _pauseSprite.draw(center);
        else*/
        _playSprite.draw(center);
    }
}

final class RewindButton : Button {
    private {
        Sprite _rewindSprite;
    }

    this() {
        _rewindSprite = fetch!Sprite("rewind");
        size = Vec2f(24f, 24f);
    }

    override void onSubmit() {
        restartScript();
    }

    override void update(float deltaTime) {
        super.update(deltaTime);
        if (getButtonDown(KeyButton.r))
            onSubmit();
    }

    override void draw() {
        if (isClicked) {
            drawFilledRect(origin, size, Color(204, 228, 247));
            drawRect(origin, size, Color(0, 84, 153));
        }
        else if (isHovered) {
            drawFilledRect(origin, size, Color(229, 241, 251));
            drawRect(origin, size, Color(0, 120, 215));
        }
        else {
            drawFilledRect(origin, size, Color(225, 225, 225));
            drawRect(origin, size, Color(173, 173, 173));
        }
        _rewindSprite.draw(center);
    }
}

final class StopButton : Button {
    private {
        Sprite _stopSprite;
    }

    this() {
        _stopSprite = fetch!Sprite("stop");
        size = Vec2f(24f, 24f);
    }

    override void onSubmit() {
        killScript();
    }

    override void update(float deltaTime) {
        super.update(deltaTime);
        if (getButtonDown(KeyButton.s))
            onSubmit();
    }

    override void draw() {
        if (isClicked) {
            drawFilledRect(origin, size, Color(204, 228, 247));
            drawRect(origin, size, Color(0, 84, 153));
        }
        else if (isHovered) {
            drawFilledRect(origin, size, Color(229, 241, 251));
            drawRect(origin, size, Color(0, 120, 215));
        }
        else {
            drawFilledRect(origin, size, Color(225, 225, 225));
            drawRect(origin, size, Color(173, 173, 173));
        }
        _stopSprite.draw(center);
    }
}

final class ReloadButton : Button {
    private {
        Sprite _stopSprite;
    }

    this() {
        _stopSprite = fetch!Sprite("stop");
        size = Vec2f(24f, 24f);
    }

    override void onSubmit() {
        reloadScript();
    }

    override void update(float deltaTime) {
        super.update(deltaTime);
        if (getButtonDown(KeyButton.s))
            onSubmit();
    }

    override void draw() {
        if (isClicked) {
            drawFilledRect(origin, size, Color(204, 228, 247));
            drawRect(origin, size, Color(0, 84, 153));
        }
        else if (isHovered) {
            drawFilledRect(origin, size, Color(229, 241, 251));
            drawRect(origin, size, Color(0, 120, 215));
        }
        else {
            drawFilledRect(origin, size, Color(225, 225, 225));
            drawRect(origin, size, Color(173, 173, 173));
        }
        _stopSprite.draw(center);
    }
}
