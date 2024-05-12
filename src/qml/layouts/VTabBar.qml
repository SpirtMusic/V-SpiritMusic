import QtQuick
import QtQuick.Controls
import Theme
import "../controls"
TabBar {
    id: tabBar
    currentIndex: 0
    background: Rectangle {
        color: Theme.colorBackground
    }
    VTabButton{
        tabBarCurrentItem:tabBar.currentItem
        imageSource:"qrc:/vsonegx/qml/imgs/music.svg"
    }
    VTabButton{
        tabBarCurrentItem:tabBar.currentItem
        imageSource:"qrc:/vsonegx/qml/imgs/music.svg"
    }
}


