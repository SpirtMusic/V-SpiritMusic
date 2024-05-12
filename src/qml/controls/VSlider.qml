import QtQuick
import QtQuick.Controls
import QtQuick 2.12
import QtQuick.Controls 2.12

Slider {
    id: slider
    property color backgroundColor: "#41474d"
    property color selectColor: "#ff6127"
    property color colorUnselect: "#ffffff"
    property color colorBorder: "#26282a"

    value: 0.5
    orientation: Qt.Vertical

    background: Rectangle {
        x: slider.leftPadding + slider.availableWidth / 2 - width / 2
        y: slider.topPadding
        implicitWidth: 4
        implicitHeight: 100
        width: implicitWidth
        height: slider.availableHeight
        radius: 2
        color: slider.colorUnselect

        Rectangle {
            y: slider.visualPosition * parent.height
            width: parent.width
            height: (1 - slider.visualPosition) * parent.height
            color: slider.selectColor
            radius: 2
        }
    }

    handle: Rectangle {
        x: slider.leftPadding + slider.availableWidth / 2 - width / 2
        y: slider.visualPosition * slider.availableHeight + slider.topPadding - height / 2
        implicitWidth: 26
        implicitHeight: 26
        radius: 13
        color: slider.pressed ? "#f0f0f0" : slider.colorUnselect
        border.color: slider.colorBorder
    }
}
