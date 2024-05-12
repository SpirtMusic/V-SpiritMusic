import QtQuick
import QtQuick.Controls
GroupBox {
    id:groupBox
    property color textColor: "#ff6127"
    property color colorSelect: "#ff6127"

    title: qsTr("GroupBox")

    label: Label {
        x: groupBox.leftPadding
        width: groupBox.availableWidth
        text: groupBox.title
        color: groupBox.textColor
        elide: Text.ElideRight
    }
    background: Rectangle {
        y: groupBox.topPadding - groupBox.bottomPadding
        width: parent.width
        height: parent.height - upperGroup.topPadding + groupBox.bottomPadding
        color: "transparent"
        border.color: groupBox.colorSelect
        radius: 4
    }
}
