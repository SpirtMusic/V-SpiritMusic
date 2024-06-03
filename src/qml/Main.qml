import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Theme
import "layouts"
import "controls"
import "views"
ApplicationWindow {
    id: rootAppWindow
    property real winBaseWidth: 800
    property real winBaseHeight: 600

    // width: 1024
    // height: 768

    width: winBaseWidth
    height: winBaseHeight

    minimumWidth: width
    minimumHeight: height

    maximumWidth:width
    maximumHeight: height
    //    flags: Qt.FramelessWindowHint | Qt.Window
    visible: true
    title: qsTr("vsonegxapp")
    color:"#2a2e32"
    header:VTabBar{
        id:tabBar
        z:1000

    }
    Rectangle {
        id : decorator;
        property real targetX: tabBar.currentItem.x
        anchors.top: tabBar.bottom;
        anchors.topMargin: 2
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


    StackLayout {
        anchors.fill: parent
        currentIndex: tabBar.currentIndex
        Layers{
        }
        Item{}
        Item{}
        Settings{}
    }

}
