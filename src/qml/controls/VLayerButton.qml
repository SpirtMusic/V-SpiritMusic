import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    property int baseWidth: rootAppWindow.winBaseWidth
    property int baseHeight: rootAppWindow.winBaseHeight
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight

    property color textColor: "#ffffff"
    property color colorSelect: "#ff6127"
    property color colorUnselect: "#ffffff"
    property color colorBorder: "#26282a"
    property color colorBackgroundButton: "#41474d"
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
    radius: 4
    border.color: colorBorder
    border.width: 1
    color: checked ? colorSelect : colorBorder
    Text {
        anchors.fill: parent
        text: vLayerButton.textLayer
        color: vLayerButton.checked ? vLayerButton.colorUnselect : vLayerButton.colorSelect
        font.bold: true
        font.pointSize: 18
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            vLayerButton.checked = !vLayerButton.checked
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: 70
        }
    }
    //  onHeightChanged: {
    // console.log("fffffff")
    //  width=Math.min(width, height)
    // }
    // onWidthChanged: {
    //     height=Math.min(width, height)

    // }
}
