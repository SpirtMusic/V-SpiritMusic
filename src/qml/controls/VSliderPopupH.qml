import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts
Rectangle{
    id:sliderItem
    property int baseWidth: rootAppWindow.winBaseWidth
    property int baseHeight: rootAppWindow.winBaseHeight
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight
    property real fontScale: Math.min(widthScale, heightScale)
    property string sliderLabel: "Volume"
    property string sliderUnit: "%"
    property int sliderpreferredHeight: 16
    property int sliderpreferredWidth: 200 //* widthScale
    property int sliderValue: 0
    property var emitterControl: null
    Layout.preferredHeight: sliderpreferredHeight
    property alias control: control
    //    Layout.preferredWidth: sliderpreferredWidth
    anchors.fill:parent
    color:"transparent"
    height: sliderpreferredHeight
    width: sliderpreferredWidth  + ( 40* widthScale) // for text
    Row{
        anchors.fill:parent
        spacing:3
        Slider {
            property real sliderHight: 10
            property real sliderWidth: sliderpreferredWidth - valueText.width
            anchors.verticalCenter: parent.verticalCenter

            id: control
            value: sliderValue
            from:0
            to:100
            stepSize:1
            Behavior on value {
                NumberAnimation {
                    duration: 100
                }
            }

            // onValueChanged: {
            //     console.log("Slider value changed to: " + value)
            //     // Add your custom logic here
            // }
             background: Rectangle {
                implicitWidth:control.sliderWidth
                implicitHeight: control.sliderHight
                radius: 2
                color:"transparent"
                Rectangle {
                    x: control.leftPadding + 10
                    y: control.topPadding + control.availableHeight / 2 - height / 2
                    implicitWidth: 150
                    implicitHeight: 4
                    width: control.availableWidth -20
                    height: implicitHeight
                    radius: 2
                    color: "#353532"
                    Rectangle {
                        width: control.visualPosition * parent.width
                        height: parent.height
                        color: "#004de8"
                        radius: 2
                        layer.enabled: true
                        layer.effect: Glow {
                            radius: 64
                            spread: 0.1
                            samples: 128
                            color: "#004de8"
                            visible: true
                        }
                    }
                }
            }
            handle:Image {
                id:handler
                x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
                y: control.topPadding + control.availableHeight / 2 - height / 2
                source: "qrc:/vsonegx/qml/controls/resource/slider/slider_handler_H.png"
                sourceSize.height:12
                Rectangle{
                    id:activeRec
                    //  anchors.centerIn: handler
                    anchors.centerIn: handler //: handler.verticalCenter
                    // x: handler.x  - 3
                    y:handler.y-3
                    height: handler.height -1
                    width: 4
                    color:control.value==0 ? "#ff0000" : "#55ff00"
                }
                Glow {
                    anchors.fill: activeRec
                    radius: 64
                    spread: 0.5
                    samples: 128
                    color: control.value==0 ? "#ff0000" : "#55ff00"
                    source: activeRec
                    visible: true
                }
            }



        }
        Text {
            id: valueText
            text: Math.trunc(control.value)  + sliderItem.sliderUnit
            //Layout.alignment: Qt.AlignRight
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            font.pointSize: 10 *fontScale
        }
    }
}
