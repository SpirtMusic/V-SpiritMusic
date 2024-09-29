import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
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

    property string iconSource: ""
    property real iconSizeRatio: 0.6
    property real implicitHeightPadding: 20
    property real fontPixelSize: 16

    property bool isFlashing: false
    property bool isBlink: isFlashing
    property color flashColor: "red" // Color to flash
    property int selectIndex: 0
    text: qsTr("Button")

    implicitWidth:55 //contentItem.implicitWidth  + 20 //* widthScale //* widthScale
    implicitHeight: 55 //contentItem.implicitHeight * heightScale + implicitHeightPadding * heightScale

    contentItem:RowLayout {
        anchors.centerIn: parent
        spacing: 2 //* widthScale
        Image {
            id: buttonIcon
            source: control.iconSource
            sourceSize.width: control.iconSizeRatio * parent.height
            sourceSize.height: control.iconSizeRatio * parent.height
            visible: control.iconSource !== ""
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: sourceSize.width
            Layout.preferredHeight: sourceSize.height
            opacity: enabled ? 1 : 0.3
            ColorOverlay {
                color: control.down ? Theme.colorHover : colorSelect
                anchors.fill: parent
                source: parent
                antialiasing: true
                // cached: true
            }
        }

        Text {
            text: control.text
            font.pixelSize:  fontPixelSize
            opacity: enabled ? 1.0 : 0.3
            color: control.down ? Theme.colorHover : Theme.colorText
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            Layout.fillWidth: true
            Layout.fillHeight: true
            font.bold: true
        }
    }

    // background: Rectangle {
    //     opacity: enabled ? 1 : 0.3
    //     implicitWidth: 100 //* widthScale
    //     implicitHeight: 40 * heightScale
    //     border.color: control.down ? Theme.colorHover : colorSelect
    //     color: "transparent"
    //     border.width: 1
    //     radius: 2

    // }
    background: Rectangle {
        id: buttonBackground
        opacity: enabled ? 1 : 0.3
        implicitWidth: 55
        implicitHeight: 55
        border.color: control.isFlashing ?  colorSelect : (control.down ? Theme.colorHover : colorSelect)
        color: "transparent"
        border.width: 1
        radius: 2

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
            id: mask
            source: "qrc:/vsonegx/qml/controls/resource/effects/fog_effect.png"
            // sourceSize: Qt.size(parent.width, parent.height)
            smooth: true
            visible: true
        }

        OpacityMask {
            anchors.fill: buttonBackground
            source: mask
            maskSource: mask
            z:80
        }
        Image {
            id: maskLayer
            source: "qrc:/vsonegx/qml/controls/resource/effects/onMemory.png"
            height: buttonBackground.height
            width: buttonBackground.width
            // smooth: true
            visible: isBlink
            opacity: 0.2
        }
        Glow {
            anchors.fill: maskLayer
            radius: 50
            spread: 0.3
            samples: 128
            color:"#fc6b03"
            source: maskLayer
            visible: isBlink
        }
        OpacityMask {
            id: opacityMask
            anchors.fill: buttonBackground
            source: maskLayer
            z: 99  // Ensure it's on top of all other children
            maskSource: maskLayer
            opacity: isBlink ? 0.7 : 0.0
        }
        Rectangle {
            id:glowRec
            anchors.fill: buttonBackground
            color:"transparent"
            border.color:  isBlink ? "#fc6b03" : "#085cb5"
            z:9999
        }
        Glow {
            anchors.fill: glowRec
            radius: 64
            spread: 0.5
            samples: 128
            color:"#fc6b03"
            source: glowRec
            visible: isBlink
        }

    }
    // Update the timer based on the isFlashing property

}
