import QtQuick
import QtQuick.Controls
import Theme
import "layouts"

ApplicationWindow {
    id: rootAppWindow
    width: 1024
    height: 768
    minimumWidth: 800
    minimumHeight: 600
    visible: true
    title: qsTr("vsonegxapp")
    header:VTabBar{
        id:tabBar
    }
    Rectangle {
        id : decorator;
        property real targetX: tabBar.currentItem.x
        anchors.top: tabBar.bottom;
        width: tabBar.currentItem.width -10 ;
        height: 1;
        color: Theme.colorSelect
        NumberAnimation on x {
            duration: 200;
            to: decorator.targetX+5
            running: decorator.x != decorator.targetX
        }
        Component.onCompleted: {
            decorator.x = decorator.targetX+5
        }
    }
}
