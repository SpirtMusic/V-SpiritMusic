import QtQuick
import Qt5Compat.GraphicalEffects
import Theme
Rectangle {
    id:indicator
    width: 20
    height: 20
    border.color: indicator.color
    radius: 10
    layer.enabled: true
    layer.effect: Glow {
        radius: 64
        spread: 0.1
        samples: 128
        color: indicator.color
        visible: true
    }
}

