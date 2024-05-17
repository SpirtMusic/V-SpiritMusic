import QtQuick
import QtQuick.Controls

SplitView {
    property int baseWidth: rootAppWindow.winBaseWidth
    property int baseHeight: rootAppWindow.winBaseHeight
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight
    property int selectedLayout: 0
    property real fontScale: Math.max(widthScale, heightScale)
    property bool toggled: true
    property bool toggle: true
    id:vSplitView
    orientation: Qt.Vertical

    handle: Rectangle {

        implicitWidth: 2
        implicitHeight: 2
        color: SplitHandle.pressed ? "#a33e19"
                                   : (SplitHandle.hovered ? Qt.lighter("#ff6127", 1.1) : "#ff6127")
        Loader {
            width: 30 * widthScale
            height: 16 * heightScale
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            sourceComponent: toggle ? toogleButton : null

            Component {
                id: toogleButton
                Rectangle {
                    width: 30 * widthScale
                    height: 16 * heightScale
                    color: "#26282a"
                    border.color: "#ff6127"
                    Text {
                        property string toggled: String.fromCodePoint(0x25B8) + " " + String.fromCodePoint(0x25B4)
                        property string untoggled: String.fromCodePoint(0x25C2) +  " " + String.fromCodePoint(0x25BE)
                        anchors.fill: parent
                        color: "#ff6127"
                        text: vSplitView.toggled ?  toggled  : untoggled
                        fontSizeMode: Text.Fit
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 14 * fontScale
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                vSplitView.toggled = !vSplitView.toggled
                            }
                        }
                    }
                }
            }
        }

    }
}
