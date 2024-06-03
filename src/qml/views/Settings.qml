import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../layouts/settings"
import "../controls"
import Theme
Item {

    TabBarSettings{
        id:tabBarSettings
        anchors.top: parent.top
        anchors.topMargin: 3
        width: parent.width

        anchors.horizontalCenter:parent.horizontalCenter
    }
    Rectangle {
        id : decorator;
        property real targetX: tabBarSettings.currentItem.x
        anchors.top: tabBarSettings.bottom;

        width: tabBarSettings.currentItem.width -10 ;
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
