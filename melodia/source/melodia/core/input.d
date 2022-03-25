/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module melodia.core.input;

import atelier;

private {
    enum _deadZone1 = 0.125f;
    enum _deadZone2 = 0.4f;
    enum INPUT_START_TIME = .25f;
    enum INPUT_HELD_TIME = .05f;
    bool[4] _dirButtons;
    Timer[4] _dirTimers, _dirTimeoutTimers;
}

/// Handle the timing
private bool updateAutoFire(int index, bool value) {
    if (index == -1)
        return false;

    if (_dirButtons[index] != value) {
        _dirButtons[index] = value;
        _dirTimers[index].start(_dirTimeoutTimers[index].isRunning ? INPUT_HELD_TIME : INPUT_START_TIME);
        _dirTimeoutTimers[index].start(5f);
        return value;
    }

    if (value) {
        if (_dirTimers[index].isRunning)
            return false;
        _dirTimers[index].start(_dirTimeoutTimers[index].isRunning ? INPUT_HELD_TIME : INPUT_START_TIME);
        _dirTimeoutTimers[index].start(5f);
    }
    else {
        _dirTimeoutTimers[index].stop();
        return false;
    }
    return true;
}

void updateInputs(float deltaTime) {
    for (int i; i < 4; ++i) {
        _dirTimers[i].update(deltaTime);
        _dirTimeoutTimers[i].update(deltaTime);
    }
}

bool isInputUp() {
    return isButtonDown(KeyButton.up) || isButtonDown(ControllerButton.up)
        || getAxis(ControllerAxis.leftY) < -_deadZone1;
}

bool isInputDown() {
    return isButtonDown(KeyButton.down) || isButtonDown(ControllerButton.down)
        || getAxis(ControllerAxis.leftY) > _deadZone1;
}

bool isInputLeft() {
    return isButtonDown(KeyButton.left) || isButtonDown(ControllerButton.left)
        || getAxis(ControllerAxis.leftX) < -_deadZone1;
}

bool isInputRight() {
    return isButtonDown(KeyButton.right) || isButtonDown(ControllerButton.right)
        || getAxis(ControllerAxis.leftX) > _deadZone1;
}

bool getInputUp() {
    return updateAutoFire(0, isButtonDown(KeyButton.up) || isButtonDown(ControllerButton.up)
            || getAxis(ControllerAxis.leftY) < -_deadZone2);
}

bool getInputDown() {
    return updateAutoFire(1, isButtonDown(KeyButton.down) || isButtonDown(ControllerButton.down)
            || getAxis(ControllerAxis.leftY) > _deadZone2);
}

bool getInputLeft() {
    return updateAutoFire(2, isButtonDown(KeyButton.left) || isButtonDown(ControllerButton.left)
            || getAxis(ControllerAxis.leftX) < -_deadZone2);
}

bool getInputRight() {
    return updateAutoFire(3, isButtonDown(KeyButton.right) || isButtonDown(ControllerButton.right)
            || getAxis(ControllerAxis.leftX) > _deadZone2);
}

bool getInputPrevious() {
    return getButtonDown(ControllerButton.leftShoulder);
}

bool getInputNext() {
    return getButtonDown(ControllerButton.rightShoulder);
}

bool getInputListPrevious() {
    return getInputPrevious() || getInputLeft() || getInputUp();
}

bool getInputListNext() {
    return getInputNext() || getInputRight() || getInputDown();
}

bool getInputValidate() {
    return getButtonDown(KeyButton.z) || getButtonDown(ControllerButton.a);
}

bool getInputCancel() {
    return getButtonDown(KeyButton.x) || getButtonDown(ControllerButton.b);
}
