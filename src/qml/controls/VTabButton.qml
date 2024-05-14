import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts

TabButton {
    id:tabButton
    property color textColor: "#ffffff"
    property color iconColor: "#ffffff"
    property color backgroundColor: "#41474d"
    property color selectColor: "#ff6127"
    property int baseWidth: rootAppWindow.winBaseWidth
    property int baseHeight: rootAppWindow.winBaseHeight
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight
    property int iconHeight: 24
    property int iconWidth: 24
    property url imageSource: "qrc:/file.svg"
    property Item tabBarCurrentItem

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
                font.pointSize:12
                elide: Text.ElideRight
            }
        }
    }
    background: Rectangle {
        implicitWidth: widthScale * 100
        implicitHeight: heightScale * 40
        color:  tabButton.backgroundColor
        radius: 4
    }
}
