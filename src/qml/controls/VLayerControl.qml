import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
Rectangle{
    id:layerControl
    property int baseWidth: 1024
    property int baseHeight: 768
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight
    property color textColor: "#ffffff"
    property color iconColor: "#ffffff"
    property color backgroundColor: "#41474d"
    property color selectColor: "#ff6127"
    property string voiceName: "voice 1"

    color:backgroundColor
    radius: 4
    height: 50 * heightScale
    width: 120 * widthScale
    Rectangle{
        color: layerControl.backgroundColor
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 2
        anchors.topMargin: 2
        anchors.rightMargin: 2
        height: parent.height/2

        Rectangle{
            height: parent.height
            width: 40 * widthScale
            anchors.left: parent.left
            anchors.top:parent.top
            color:layerControl.backgroundColor
            z:1
            Text {
                text: "-"
                font.pixelSize: voiceControl.font.pixelSize * 2
                color: "#ff6127"
                anchors.fill: parent
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
        SpinBox {
            id: voiceControl
            anchors.top:parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height
            value: 50
            to:100

            up.indicator:Item{
                visible: false
            }
            down.indicator:Item{
                visible: false
            }
            contentItem: Rectangle {
                anchors.fill: parent
                color:layerControl.backgroundColor
                Text {
                    anchors.centerIn: parent
                    z: 2
                    text: voiceControl.textFromValue(voiceControl.value, voiceControl.locale)
                    color: layerControl.textColor
                }
            }
        }
        Rectangle{
            height: parent.height
            width: 40 * widthScale
            anchors.right: parent.right
            anchors.top:parent.top
            color:layerControl.backgroundColor
            Text {
                text: "+"
                font.pixelSize: voiceControl.font.pixelSize * 2
                color: "#ff6127"
                anchors.fill: parent
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

    }
    Text {
        width: parent.width
        anchors.bottom:parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 2
        anchors.bottomMargin: 2
        anchors.rightMargin: 2
        color: layerControl.textColor
        text: layerControl.voiceName
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}

