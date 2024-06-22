import QtQuick
import QtQuick.Controls
import Theme
Button {
    id: control
    property int baseWidth: rootAppWindow.winBaseWidth
    property int baseHeight: rootAppWindow.winBaseHeight
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight
    property real fontScale: Math.min(widthScale, heightScale)
    property color textColor: Theme.colorText
    property color colorSelect: Theme.colorSelect
    property color colorBorder: Theme.colorBorder
    text: qsTr("Button")

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: control.down ? Theme.colorHover : colorSelect
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 40
        opacity: enabled ? 1 : 0.3
        border.color: control.down ? Theme.colorHover : colorSelect
        color:"transparent"
        border.width: 1
        radius: 2
    }
}
