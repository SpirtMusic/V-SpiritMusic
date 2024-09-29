import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Theme

RowLayout {
    // anchors.fill: parent
    property int baseWidth: rootAppWindow.winBaseWidth
    property int baseHeight: rootAppWindow.winBaseHeight
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight
    property real fontScale: Math.min(widthScale, heightScale)

    spacing: 5
    property int currentSelectedIndex: 0
    Repeater {
        model: 10

        delegate: VRegistraionsButton {
            text: (model.index + 1).toString()
            selectIndex: model.index + 1
            isFlashing: model.index === currentSelectedIndex
            onClicked: {
                currentSelectedIndex = model.index
                sm.loadRegistration(  model.index + 1)
            }
        }
    }
    Component.onCompleted: {
        sm.loadRegistration(currentSelectedIndex+1)
    }
    Connections{
        target: mc
        function onBankNumberChanged(){
            currentSelectedIndex=mc.bankNumber-1
            sm.loadRegistration(mc.bankNumber)
        }

    }
}

