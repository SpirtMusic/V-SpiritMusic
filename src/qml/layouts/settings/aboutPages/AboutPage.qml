import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Theme
import "../../../controls"
Item {
    property int baseWidth: rootAppWindow.winBaseWidth
    property int baseHeight: rootAppWindow.winBaseHeight
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight
    property real fontScale: Math.min(widthScale, heightScale)
    RowLayout{
        id:aboutlayout
        anchors.centerIn: parent
        Text{
            text: "DEV version : ("+appVersion +")  0.3 V"
            color:"white"
        }
    }
}

