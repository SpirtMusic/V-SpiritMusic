import QtQuick
import QtQuick.Controls
import Theme
import "../controls"
TabBar {
    id: tabBar
    currentIndex: 0
    property bool enableScaling: true

    background: Rectangle {
        color:Theme.colorBackground
    }
    VTabButton{
        text:"SoneGX"
        tabBarInstance: tabBar
        tabBarCurrentItem:tabBar.currentItem
        imageSource:"qrc:/vsonegx/qml/imgs/th.svg"
        //backgroundColor:Theme.colorBackground
    }
    VTabButton{
        text:"Sounds"
        tabBarInstance: tabBar
        tabBarCurrentItem:tabBar.currentItem
        imageSource:"qrc:/vsonegx/qml/imgs/music.svg"
       // backgroundColor:Theme.colorBackground
    }
    VTabButton{
        text:"Setup Sounds"
        tabBarInstance: tabBar
        tabBarCurrentItem:tabBar.currentItem
        imageSource:"qrc:/vsonegx/qml/imgs/sliders-h.svg"
       // backgroundColor:Theme.colorBackground
    }
    VTabButton{
        text:"Settings"
        tabBarInstance: tabBar
        tabBarCurrentItem:tabBar.currentItem
        imageSource:"qrc:/vsonegx/qml/imgs/wrench.svg"
      //  backgroundColor:Theme.colorBackground
    }

}


