import QtQuick
import QtQuick.Controls

Switch {
    id: layerButton
    property int baseWidth: 1024
    property int baseHeight: 768
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight
    property color textColor: "#ffffff"
    property color colorSelect: "#ff6127"
    property color colorUnselect: "#ffffff"
    property color colorBorder: "#26282a"
    property string textLayer: "1"

    width: widthScale*100
    height: heightScale*100
    property bool switchToggled: false
    indicator: Rectangle {
        color: layerButton.checked ? layerButton.colorSelect : layerButton.colorUnselect
        radius: 4
        border.color: layerButton.colorBorder
        border.width: 1
        implicitWidth: widthScale*100
        implicitHeight: heightScale*100
        Behavior {
            ColorAnimation {
                duration: 50
            }
        }
        Text {
            anchors.fill: parent
            text: layerButton.textLayer
            color: layerButton.checked ? layerButton.colorUnselect : layerButton.colorSelect
            font.bold:true
            font.pointSize:24
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }
}
