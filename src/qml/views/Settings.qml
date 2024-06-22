import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../layouts/settings"
import "../layouts/settings/settingsPages"
import "../controls"
import Theme
import Qt5Compat.GraphicalEffects
Item {

    TabBarSettings{
        id:tabBarSettings
        anchors.top: parent.top
        anchors.topMargin: 0
        width: parent.width

        anchors.horizontalCenter:parent.horizontalCenter
    }
    Rectangle {
        id : decoratorSettings;
        property real targetX: tabBarSettings.currentItem.x
        anchors.top: tabBarSettings.bottom;

        width: tabBarSettings.currentItem.width -10 ;
        height: 1;
        color: Theme.colorSelect
        NumberAnimation on x {
            duration: 200;
            to: decoratorSettings.targetX+5
            running: decoratorSettings.x != decoratorSettings.targetX
        }
        Component.onCompleted: {
            decoratorSettings.x = decoratorSettings.targetX+5
        }
        layer.enabled: true
        layer.effect: Glow {
            radius: 64
            spread: 0.5
            samples: 128
            color: Theme.colorSelect
            visible: true
        }
    }
    StackLayout {
        //anchors.fill: parent
        anchors.top: decoratorSettings.bottom

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        currentIndex: tabBarSettings.currentIndex


        ConnectionsPage{}

        Item{}

    }
}
