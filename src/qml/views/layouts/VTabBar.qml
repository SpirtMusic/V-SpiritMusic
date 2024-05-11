import QtQuick
import QtQuick.Controls
import Theme
TabBar {
 id: tabBar
currentIndex: 0
background: Rectangle {
       color: Theme.colorBackground
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
