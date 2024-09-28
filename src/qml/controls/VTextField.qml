import QtQuick
import QtQuick.Controls.Basic
import Theme
TextField {
    id: control

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 40
        color: control.enabled ? "transparent" : "#353637"
        border.color: control.enabled ? Theme.colorSelect : "transparent"
    }
}
