import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Theme
Rectangle {
    property int baseWidth: rootAppWindow.winBaseWidth
    property int baseHeight: rootAppWindow.winBaseHeight
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight
    property real fontScale: Math.min(widthScale, heightScale)

    property color textColor: Theme.colorText
    property color colorSelect:Theme.colorSelect
    property color colorUnselect:  Theme.colorUnselect
    property color colorBorder: Theme.colorButtonBackground
    property color colorBackgroundButton:    Theme.colorButtonBackground
    property string textLayer: "1"
    property bool checked: false
    property bool layerToggled: false


    property int layerNumber: 0
    property int layerSet


    id: vLayerButton
    Layout.margins: 2
    Layout.fillHeight: true
    Layout.fillWidth:true
    Layout.preferredWidth: 60 * widthScale
    Layout.preferredHeight: 60 * heightScale
    radius: 2
    border.color: "#2f4967"
    border.width: 2
    color:  colorBorder

    onCheckedChanged: {
        if (mc) {
            mc.setLayerEnabled(vLayerButton.layerSet, layerNumber, checked)
            sm.saveLayerEnabled(vLayerButton.layerSet, layerNumber, checked)
        }
    }

    Image {
        id: mask
        source: "qrc:/vsonegx/qml/controls/resource/effects/fog_effect.png"
        // sourceSize: Qt.size(parent.width, parent.height)
        smooth: true
        visible: false
    }

    OpacityMask {
        anchors.fill: parent
        source: mask
        maskSource: mask
        z:80
    }

    Rectangle {
        id:recMask
        anchors.fill: parent
        z: 99  // Ensure it's on top of all other children
        color:Theme.colorButtonBackground
        border.color:  "transparent"

        opacity: 0.7  // Adjust opacity as needed
        gradient: Gradient {
            GradientStop { position: 0.0; color:  "#527eb5ff"}
            GradientStop { position: 0.55; color:  "transparent"}
            GradientStop { position: 1.0; color:   "transparent"}
        }

    }


    Image {
        id: maskLayer
        source: "qrc:/vsonegx/qml/controls/resource/effects/onLayer.png"
        smooth: true
        visible: checked
    }

    OpacityMask {
        id: opacityMask
        anchors.fill: parent
        source: maskLayer
        z: 99  // Ensure it's on top of all other children
        maskSource: maskLayer
        opacity: checked ? 0.7 : 0.0


    }


    Text {
        anchors.fill: parent
        text: vLayerButton.textLayer
        color:  vLayerButton.colorUnselect
        font.bold: true
        font.pointSize: 12  *fontScale
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        z: checked ? 100 : 1
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            vLayerButton.checked = !vLayerButton.checked
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: 2000
        }
    }



    layer.enabled: true
    layer{effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 1
            verticalOffset: 1
        }

    }

    Component.onCompleted: {
        checked = sm.getLayerEnabled(layerSet, layerNumber)
    }


}
