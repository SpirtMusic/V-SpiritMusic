import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Theme

Button {
    id: control

    property int baseWidth: rootAppWindow.winBaseWidth
    property int baseHeight: rootAppWindow.winBaseHeight
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight
    property real fontScale: Math.min(widthScale, heightScale)

    property color textColor: Theme.colorText
    property color colorSelect: Theme.colorSelect
    property color colorBorder: Theme.colorBorder

    property string iconSource: ""
    property real iconSizeRatio: 0.6
    property real implicitHeightPadding: 20
    property real fontPixelSize: 12

    text: qsTr("Button")

    implicitWidth: contentItem.implicitWidth  + 20 //* widthScale //* widthScale
    implicitHeight: contentItem.implicitHeight * heightScale + implicitHeightPadding * heightScale

    contentItem:RowLayout {
        anchors.centerIn: parent
        spacing: 2 //* widthScale
        Image {
            id: buttonIcon
            source: control.iconSource
            sourceSize.width: control.iconSizeRatio * parent.height
            sourceSize.height: control.iconSizeRatio * parent.height
            visible: control.iconSource !== ""
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: sourceSize.width
            Layout.preferredHeight: sourceSize.height
            opacity: enabled ? 1 : 0.3
            ColorOverlay {
                color: control.down ? Theme.colorHover : colorSelect
                anchors.fill: parent
                source: parent
                antialiasing: true
                // cached: true
            }
        }

        Text {
            text: control.text
            font.pixelSize:  fontPixelSize
            opacity: enabled ? 1.0 : 0.3
            color: control.down ? Theme.colorHover : colorSelect
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    background: Rectangle {
        opacity: enabled ? 1 : 0.3
        implicitWidth: 100 //* widthScale
        implicitHeight: 40 * heightScale
        border.color: control.down ? Theme.colorHover : colorSelect
        color: "transparent"
        border.width: 1
        radius: 2
    }
}
