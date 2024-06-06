import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Theme
import Qt5Compat.GraphicalEffects
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
    color: Theme.colorBackground
    header:VTabBar{
        id:tabBar
        z:1000
        background: Rectangle {
            anchors.fill: parent
            color : Theme.colorBackgroundView
        }
    }
    Rectangle {
        id : decorator;
        property real targetX: tabBar.currentItem.x
        anchors.top: tabBar.bottom;
        anchors.topMargin: 2
        width: tabBar.currentItem.width -10 ;
        height: 1;
        z:99
        color: Theme.colorSelect
        NumberAnimation on x {
            duration: 200;
            to: decorator.targetX+5
            running: decorator.x != decorator.targetX
        }
        Component.onCompleted: {
            decorator.x = decorator.targetX+5
        }
        layer.enabled: true
        layer.effect: Glow {
            radius: 64
            spread: 0.5
            samples: 128
            color: "#ff6127"
            visible: true
        }
    }
    Image {
        id: mask
        source: "qrc:/vsonegx/qml/controls/resource/texture/tx3.jpg"
       // sourceSize: Qt.size(parent.width, parent.height)
        smooth: true
        visible: false
    }

    OpacityMask {
        anchors.fill: parent
        source: mask
        maskSource: mask
    }

    StackLayout {
        anchors.fill: parent
        anchors.top: decorator.bottom
        currentIndex: tabBar.currentIndex
        Layers{
        }
        Item{}
        Item{}
        Settings{}
    }

}
