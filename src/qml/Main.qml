import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Theme
import Qt5Compat.GraphicalEffects
import "layouts"
import "layouts/layers"
import "controls"
import "views"
import com.sonegx.settingsmanager
import com.sonegx.midiclient
ApplicationWindow {
    id: rootAppWindow
    property real winBaseWidth: 800
    property real winBaseHeight: 600
    property alias sm: settingsmanager
    property int selectedControlIndex:0
    property string currentCategory: ""
    property string currentCategoryMain:""
    property VLayerControl controlIndexSounds:null
    property bool isCurrentCategoryEditable: true
    property int currentCategoryLevel: 0
    property  var vControlLayers:[]
    property VLayersControlContainer vLayersControlContainerGlobal : null
    property int globalTabIndex: 0

    property string globalSourceCategory: ""
    property string globalDestCategory: ""
    property string globalSoundName: ""
    // width: 1024
    // height: 768

    width: winBaseWidth
    height: winBaseHeight

    // minimumWidth: width
    // minimumHeight: height

    // maximumWidth:width
    // maximumHeight: height
    //    flags: Qt.FramelessWindowHint | Qt.Window
    visible: true
    title: qsTr("VSpiritMusic")
    color: Theme.colorBackground
    header:VTabBar{
        id:tabBar
        z:1000
        background: Rectangle {
            anchors.fill: parent
            color : Theme.colorBackgroundView
        }
        // Bind the TabBar's currentIndex to the global property
        currentIndex: rootAppWindow.globalTabIndex
        onCurrentIndexChanged: rootAppWindow.globalTabIndex = currentIndex
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
            color: Theme.colorSelect
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
        Layers{}
        Sounds{}
        Item{}
        Settings{}
    }
    SettingsManager{
        id:settingsmanager

    }
    MidiClient{
        id: mc

    }
    Component.onCompleted: {

    }

}
