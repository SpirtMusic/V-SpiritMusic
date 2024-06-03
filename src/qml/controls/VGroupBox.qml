import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
GroupBox {
    id:groupBox
    property color textColor: "#ffffff"
    property color colorSelect: "#ff6127"
    property color colorBorder: "#67707a"
    property string tmpTitle: title
    title: qsTr("GroupBox")
    label:Item{
        Label {
            x: groupBox.leftPadding
            text: groupBox.title
            color: groupBox.textColor
            elide: Text.ElideRight
            font.pixelSize: 14
           // font.bold: true
            padding: 2
            Rectangle{
                anchors.fill: parent
                border.width: 1
                color: 'transparent'
                border.color : 'transparent'
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.border.color = groupBox.colorSelect
                    onExited: parent.border.color = 'transparent'
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
        color: "#41474d"
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
        title=tmpTitle + " " +String.fromCodePoint(0x25B2)
    }
}
