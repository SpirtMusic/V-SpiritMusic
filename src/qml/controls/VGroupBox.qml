import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Theme

GroupBox {
    id:groupBox
    property int baseWidth: rootAppWindow.winBaseWidth
    property int baseHeight: rootAppWindow.winBaseHeight
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight
    property real fontScale: Math.min(widthScale, heightScale)
    property color textColor: Theme.colorText
    property color colorSelect: Theme.colorSelect
    property color colorBorder: Theme.colorBorder
    property string tmpTitle: title
    property bool collapsable: true
    title: qsTr("GroupBox")
    label:Item{
        Label {
            x: groupBox.leftPadding
            text: groupBox.title
            color: groupBox.textColor
            elide: Text.ElideRight
            font.pointSize: 10 * fontScale
            // font.bold: true
            padding: 2
            layer.enabled: true
            layer.effect: Glow {
                radius: 64
                spread: 0.5
                samples: 128
                color: Theme.colorSelect
                visible: true
            }
            Rectangle{
                anchors.fill: parent
                border.width: 1
                color: 'transparent'
                border.color : 'transparent'
                visible:collapsable
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.border.color = groupBox.colorSelect
                    onExited: parent.border.color = 'transparent'
                    enabled: collapsable
                    onClicked: {
                        if(contentItem.visible){
                            contentItem.visible=false
                            contentHeight=7
                            title=""
                            title=tmpTitle+" " +String.fromCodePoint(0x25BC)
                            groupBox.Layout.fillHeight= false

                        }
                        else{
                            contentItem.visible=true
                            contentHeight=implicitContentHeight
                            title=tmpTitle + " " +String.fromCodePoint(0x25B2)
                            groupBox.Layout.fillHeight= true
                        }
                    }

                }
            }
        }
    }
    background: Rectangle {
        y: groupBox.topPadding - groupBox.bottomPadding
        width: parent.width
        height: parent.height - groupBox.topPadding + groupBox.bottomPadding
        color:"transparent" //Theme.colorBackgroundView
        border.color: groupBox.colorBorder
        radius: 4
        Behavior on height {
            NumberAnimation {
                id: animateContentHeight
                duration: 400
                easing.type: Easing.OutQuint
            }
        }

    }
    Component.onCompleted: {
        tmpTitle=title
        if(collapsable)
        title=tmpTitle + " " +String.fromCodePoint(0x25B2)
        else
            title=tmpTitle
    }
}
