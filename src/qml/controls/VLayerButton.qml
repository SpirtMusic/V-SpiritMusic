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

    property color textColor: Theme.colorText
    property color colorSelect:Theme.colorSelect
    property color colorUnselect:  Theme.colorUnselect
    property color colorBorder: Theme.colorButtonBackground
    property color colorBackgroundButton:    Theme.colorButtonBackground
    property string textLayer: "1"
    property bool checked: false
    property bool layerToggled: false
    property real fontScale: Math.max(widthScale, heightScale)

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
    // gradient: Gradient {

    //     GradientStop { position: 0.0; color: "#38567cff" }
    //     GradientStop { position: 0.30; color: checked ? "#41cd52" :colorBorder}
    //     GradientStop { position: 0.60; color: colorBorder }
    //     GradientStop { position: 1.0; color: colorBorder }
    // }
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

    // }

    // RectangularGlow {
    //     anchors.fill: parent
    //     glowRadius: 5
    //     spread: 2
    //     color: checked ? "#41cd52" : "yellow"
    //     // visible: checked
    //     cornerRadius: parent.radius + glowRadius
    // }

    // LinearGradient {
    //     anchors.fill: parent
    //     start: Qt.point(0, 0)
    //     end: Qt.point(parent.height, parent.width)
    //         gradient: Gradient {
    //             GradientStop { position: 0.0; color:  "#527eb5ff"}
    //             GradientStop { position: 0.55; color: Theme.colorButtonBackground }
    //             GradientStop { position: 1.0; color: Theme.colorButtonBackground }
    //         }
    // }
    // LinearGradient {
    //     anchors.fill: parent
    //     start: Qt.point(parent.height/2, parent.width/2)
    //     end: Qt.point(parent.height, parent.width)
    //     gradient: Gradient {
    //         GradientStop { position: 0.0; color: colorBorder }
    //         GradientStop { position: 0.5; color:  checked ? "#41cd52" :colorBorder }
    //         GradientStop { position: 0.9; color: colorBorder }
    //         GradientStop { position: 1; color: colorBorder }
    //     }
    // }
    // LinearGradient {
    //     anchors.fill: parent
    //     start:Qt.point(parent.height, parent.width)
    //     end: Qt.point(0, 0)
    //     gradient: Gradient {
    //         GradientStop { position: 0.0; color: colorBorder }
    //         GradientStop { position: 0.5; color:  checked ? "#41cd52"  :"yellow"  }
    //         GradientStop { position: 0.9; color: colorBorder }
    //         GradientStop { position: 1; color: colorBorder }
    //     }
    // }



    // Glow {
    //     anchors.fill: parent
    //     radius: 12
    //     samples: 25
    //     spread: 0.5
    //     color: checked ? "#41cd52" :colorBorder
    //     source: recMask
    //     visible: checked
    // }

    Text {
        anchors.fill: parent
        text: vLayerButton.textLayer
        color:  vLayerButton.colorUnselect
        font.bold: true
        font.pointSize: 12
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


    //  onHeightChanged: {
    // console.log("fffffff")
    //  width=Math.min(width, height)
    // }
    // onWidthChanged: {
    //     height=Math.min(width, height)

    // }
    // DropShadow {
    //     //anchors.fill: vLayerButton
    //     horizontalOffset: 3
    //     verticalOffset: 3
    //     radius: 4.0
    //     color: "#000000"
    //     spread: 0
    //     source: vLayerButton
    // }
    layer.enabled: true
    layer{effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 1
            verticalOffset: 1
        }

    }




}
