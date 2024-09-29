import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Theme

RowLayout {
    anchors.fill: parent
    spacing: 5
    property int selectedIndex: -1
    Repeater {
        model: 10

        delegate: Rectangle {
            width: 40
            height: 40
            color: model.index === selectedIndex ? "orange" : "blue"

            Text {
                anchors.centerIn: parent
                text: (model.index + 1).toString() // Display item number
                color: "white"
                font.pixelSize: 20
            }

            MouseArea {
                anchors.fill: parent
                onClicked: selectedIndex = model.index
            }
        }
    }
}

