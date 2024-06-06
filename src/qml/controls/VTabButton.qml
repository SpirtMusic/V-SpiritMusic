import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts
import Theme
TabButton {
    id:tabButton
    property color textColor: Theme.colorText
    property color iconColor: Theme.colorText
    property color backgroundColor:    Theme.colorBackgroundView
    property color selectColor:Theme.colorSelect
    property int baseWidth: rootAppWindow.winBaseWidth
    property int baseHeight: rootAppWindow.winBaseHeight
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight
    property int iconHeight: 24
    property int iconWidth: 24
    property url imageSource: "qrc:/file.svg"
    property Item tabBarCurrentItem
    property TabBar tabBarInstance
    property real scaleFactor: 1.1
    property real fontScale: Math.max(widthScale, heightScale)

    text: qsTr("Text")
    leftInset:5
    rightInset:5
    topInset:5

    contentItem: Item {
        RowLayout{
            anchors.centerIn: parent
            spacing:10
            Image{
                source:tabButton.imageSource
                Layout.alignment: Qt.AlignHCenter
                sourceSize.width: tabButton.iconWidth
                sourceSize.height: tabButton.iconHeight

                mipmap: true
                ColorOverlay {
                    color:tabBarCurrentItem===tabButton ? tabButton.selectColor : tabButton.iconColor
                    anchors.fill: parent
                    source: parent

                    antialiasing: true
                    // cached: true
                }
            }
            Text {
                text:tabButton.text
                color:tabBarCurrentItem===tabButton ? tabButton.selectColor : tabButton.textColor
                //   font.bold:true
                font.pointSize:10 * fontScale
                elide: Text.ElideRight
                layer.enabled: tabBarCurrentItem===tabButton ? true : false
                layer.effect: Glow {
                    radius: 64
                    spread: 0.2
                    samples: 128
                    color:   "#ff6127"
                    visible: true
                }
            }

        }
    }
    background: Rectangle {
        implicitWidth: widthScale * 80
        implicitHeight: heightScale * 30
        color:  tabButton.backgroundColor
        radius: 4
    }

    ScaleAnimator {
        id: scaleAnimator
        target: tabButton
        from: 1.0
        to: tabBarInstance.currentItem === tabButton ? scaleFactor : 1.0
        duration: 200
        running: tabBarInstance.enableScaling
    }
    Connections {
        target: tabBarInstance
        function onCurrentItemChanged() {
            if (tabBarInstance.enableScaling) {
                scaleAnimator.restart()
            }
        }
    }
}
