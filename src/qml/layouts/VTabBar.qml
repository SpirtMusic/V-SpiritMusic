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
        text:"SoneGX"
        tabBarCurrentItem:tabBar.currentItem
        imageSource:"qrc:/vsonegx/qml/imgs/music.svg"
    }
    VTabButton{
        text:"Voices"
        tabBarCurrentItem:tabBar.currentItem
        imageSource:"qrc:/vsonegx/qml/imgs/sliders-h.svg"
    }
    VTabButton{
        text:"V"
        tabBarCurrentItem:tabBar.currentItem
        imageSource:"qrc:/vsonegx/qml/imgs/music.svg"
    }
    VTabButton{
        text:"Settings"
        tabBarCurrentItem:tabBar.currentItem
        imageSource:"qrc:/vsonegx/qml/imgs/cog.svg"
    }

}


