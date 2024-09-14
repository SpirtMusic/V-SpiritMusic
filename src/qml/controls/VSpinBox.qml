import QtQuick
import QtQuick.Controls
import Theme
Rectangle{
    width: 120
    color:Theme.colorBackgroundView
    property SpinBox control : control
    Text {
        id:spinBoxTtile
        z: 2
        text: "Octave"
        anchors.top: parent.top
        anchors.right:parent.right
        anchors.left:parent.left
        color:Theme.colorText

        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        anchors.margins: 4

    }
    SpinBox {
        id: control
        anchors.top :spinBoxTtile.bottom
        anchors.topMargin: 5
        value: 0
        editable: false
        from:-3
        to:3
        height: 40
        width: parent.width
        contentItem: Text {
            z: 2
            text: control.textFromValue(control.value, control.locale)
            anchors.centerIn: parent
            font: control.font
            color:Theme.colorText

            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            anchors.right:down.indicator.left
            anchors.left:up.indicator.right
            anchors.margins: 5

        }

        up.indicator: Rectangle {
            x: control.mirrored ? 0 : parent.width - width
            height: parent.height
            implicitWidth: 40
            implicitHeight: 40
            color: control.up.pressed ? "#e4e4e4" : Theme.colorBackgroundView
            border.color: enabled ? Theme.colorSelect : "#bdbebf"

            Text {
                text: "+"
                font.pixelSize: control.font.pixelSize * 2
                color: Theme.colorText
                anchors.fill: parent
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        down.indicator: Rectangle {
            x: control.mirrored ? parent.width - width : 0
            height: parent.height
            implicitWidth: 40
            implicitHeight: 40
            color: control.down.pressed ? "#e4e4e4" : Theme.colorBackgroundView
            border.color: enabled ? Theme.colorSelect : "#bdbebf"

            Text {
                text: "-"
                font.pixelSize: control.font.pixelSize * 2
                color: Theme.colorText
                anchors.fill: parent
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        background: Rectangle {
            implicitWidth: 120
            border.color: Theme.colorSelect
            color:Theme.colorBackgroundView
        }
    }
}
