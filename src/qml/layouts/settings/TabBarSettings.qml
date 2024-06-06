import QtQuick
import QtQuick.Controls
import Theme
import "../../controls"
TabBar {
    id: tabBar
    property bool enableScaling: true

    currentIndex: 0
    background: Rectangle {
        color:Theme.colorBackground
    }
    VTabButton{

        text:"Connections"
        tabBarInstance: tabBar
        tabBarCurrentItem:tabBar.currentItem
        imageSource:"qrc:/vsonegx/qml/imgs/midi.svg"

    }
    VTabButton{
        text:"Appearance"
        tabBarInstance: tabBar
        tabBarCurrentItem:tabBar.currentItem
        imageSource:"qrc:/vsonegx/qml/imgs/pencil-ruler.svg"

    }
    VTabButton{
        text:"General"
        tabBarInstance: tabBar
        tabBarCurrentItem:tabBar.currentItem
        imageSource:"qrc:/vsonegx/qml/imgs/sliders-h.svg"

    }
    VTabButton{
        text:"Profiles / Data"
        tabBarInstance: tabBar
        tabBarCurrentItem:tabBar.currentItem
        imageSource:"qrc:/vsonegx/qml/imgs/wrench.svg"

    }
    VTabButton{
        text:"About"
        tabBarInstance: tabBar
        tabBarCurrentItem:tabBar.currentItem
        imageSource:"qrc:/vsonegx/qml/imgs/info-circle.svg"

    }

}


