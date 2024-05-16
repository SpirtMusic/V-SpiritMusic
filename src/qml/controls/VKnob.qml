import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Dial {
    id: vKnob
    property int baseWidth: rootAppWindow.winBaseWidth
    property int baseHeight: rootAppWindow.winBaseHeight
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight
    property color textColor: "#ffffff"
    property color colorSelect: "#ff6127"
    property color colorpress: "#a33e19"
    property color colorUnselect: "#ffffff"
    property color colorBorder: "#26282a"
    property color colorBackgroundButton: "#41474d"
    property string knobLabel: "knob"
    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.preferredWidth: 40 * widthScale
    Layout.preferredHeight: 40 * heightScale

    from: 0
    to: 100
    stepSize:1

    background: Rectangle {
        x: vKnob.width / 2 - width / 2
        y: vKnob.height / 2 - height / 2
        width: Math.max(64, Math.min(vKnob.width, vKnob.height))
        height: width
        color: "transparent"
        radius: width / 2
        border.color: vKnob.pressed ? vKnob.colorpress : vKnob.colorSelect
        opacity: vKnob.enabled ? 1 : 0.3
        border.width: 3
    }

    handle: Rectangle {
        property real handlewWidthScale: 6 * (vKnob.width /  vKnob.Layout.preferredWidth)
        property real handlewHeightScale: 6 * (vKnob.height /  vKnob.Layout.preferredHeight)

        id: handleItem
        x: vKnob.background.x + vKnob.background.width / 2 - width / 2
        y: vKnob.background.y + vKnob.background.height / 2 - height / 2
        width:  Math.min(handlewWidthScale,handlewHeightScale)
        height:  handleItem.width
        color: vKnob.pressed ? vKnob.colorpress : vKnob.colorSelect
        radius: width/2
        antialiasing: true
        opacity: vKnob.enabled ? 1 : 0.3
        transform: [
            Translate {
                y: -Math.min(vKnob.background.width, vKnob.background.height) * 0.4 + handleItem.height / 2
            },
            Rotation {
                angle: vKnob.angle
                origin.x: handleItem.width / 2
                origin.y: handleItem.height / 2
            }
        ]
    }

    Text {
        anchors.centerIn: parent
        text: vKnob.value + "%"
        font.pixelSize: 18
        color: vKnob.textColor
        font.bold: true
    }

    Text {
        anchors.horizontalCenter: vKnob.background.horizontalCenter
        anchors.top: vKnob.background.bottom
        anchors.bottomMargin: 10
        text: vKnob.knobLabel
        font.pixelSize: 14
        color: vKnob.textColor
        elide: Text.ElideRight

    }
    onHeightChanged: {

    console.log("Knob height :" + height)
        console.log("Knob width :" + width)


    }
}
