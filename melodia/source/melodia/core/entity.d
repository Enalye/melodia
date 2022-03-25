module melodia.core.entity;

import atelier;
import melodia.core.constants, melodia.core.data;

final class Entity {
    private {
        Vec2i _position;
        bool _isGrabbed, _isEdited;
    }

    @property {
        /+string id() const {
            return _id;
        }

        string id(string id_) {
            if (_id != id_) {
                _id = id_;
                reload();
                onEntityDirty();
            }
            return _id;
        }+/

        Vec2i position() const {
            return _position;
        }

        Vec2i position(Vec2i position_) {
            if (_position != position_) {
                /*const TabData tabData = getCurrentTab();
                position_ = position_.clamp(Vec2i(TILE_SIZE, TILE_SIZE) / 2,
                    (Vec2i(tabData.width, tabData.height) - 1) * Vec2i(TILE_SIZE, TILE_SIZE));*/
                position_ = (cast(Vec2i)((cast(Vec2f)(position_ - TILE_HALFSIZE) / TILE_SIZE)
                        .round() * TILE_SIZE)) + TILE_HALFSIZE;

                onEntityDirty();
                _position = position_;
            }
            return _position;
        }
    }

    this(Entity entity) {
    }

    bool collideWith(Vec2i position_) {
        return position_.isBetween(_position - TILE_HALFSIZE, _position + TILE_HALFSIZE);
    }

    bool isInside(Vec2i start, Vec2i end) {
        return _position.isBetween(start, end);
    }

    void setEdit(bool isEdited) {
        _isEdited = isEdited;
    }

    void setGrab(bool isGrabbed) {
        _isGrabbed = isGrabbed;
    }

    void load(JSONValue json) {
    }

    JSONValue save() {
        JSONValue nothing;
        return nothing;
    }

    void reload() {

    }

    void saveHistoryFrame(bool clear = false) {

    }

    void cancelHistory() {
    }

    void restoreHistory() {
    }
}
