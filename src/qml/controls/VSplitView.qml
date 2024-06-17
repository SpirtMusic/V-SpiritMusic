import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import Theme
SplitView {
    id:vSplitView
    property int baseWidth: rootAppWindow.winBaseWidth
    property int baseHeight: rootAppWindow.winBaseHeight
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight
    property int selectedLayout: 0
    property real fontScale: Math.max(widthScale, heightScale)
    property bool toggled: true
    property bool toggle: true
    property color colorBorder: Theme.colorSelect

    orientation: Qt.Vertical

    handle: Rectangle {

        implicitWidth: 1
        implicitHeight: 2
        color: SplitHandle.pressed ? "#a33e19"
                                   : (SplitHandle.hovered ? Qt.lighter(vSplitView.colorBorder, 1.1) : vSplitView.colorBorder)

        layer.enabled: true
        layer.effect: Glow {
            radius: 64
            spread: 0.2
            samples: 128
            color: Theme.colorSelect
            visible: true
        }
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
                    border.color: Theme.colorSelect
                    Text {
                        property string toggled: String.fromCodePoint(0x25B8) + " " + String.fromCodePoint(0x25B4)
                        property string untoggled: String.fromCodePoint(0x25C2) +  " " + String.fromCodePoint(0x25BE)
                        anchors.fill: parent
                        color: Theme.colorSelect
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
