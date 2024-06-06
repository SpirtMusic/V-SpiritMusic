import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Theme
Item{
    id:sliderItem
    property string sliderLabel: "Volume"
    property string sliderUnit: "%"
    property int sliderpreferredHeight: 200
    property int sliderpreferredWidth: 40
    property int sliderValue: 0
    Layout.preferredHeight: sliderpreferredHeight
    Layout.preferredWidth: sliderpreferredWidth

    ColumnLayout{
        // Layout.alignment: Qt.AlignVCenter
        Text {
            id: valueText
            text: Math.trunc(control.value)  + sliderUnit
            Layout.alignment: Qt.AlignRight
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color:Theme.colorText
        }
        Slider {
            property real sliderHight:150
            property real sliderWidth: 6
            Layout.preferredHeight: sliderHight
            id: control
            orientation: Qt.Vertical
            Layout.alignment: Qt.AlignRight

            from:0
            to:100
            stepSize:1
            Behavior on value {
                NumberAnimation {

                    duration: 200

                }
            }

            background: Rectangle {
                implicitWidth:control.sliderWidth
                implicitHeight: control.sliderHight
                radius: 2
                color:"transparent"
                Rectangle {
                    x: control.leftPadding + control.availableWidth / 2 - width / 2
                    y: control.topPadding + 10
                    implicitWidth: control.sliderWidth
                    implicitHeight: control.sliderHight
                    width: implicitWidth
                    height: control.availableHeight - 20
                    radius: 2
                    color: "#353532"
                    Rectangle {
                        x: 0
                        height: control.availableHeight - control.visualPosition * parent.height - 30
                        width: parent.width
                        y:  control.visualPosition * parent.height + 10
                        color: "#ff6127"
                        radius: 2
                        layer.enabled: true
                        layer.effect: Glow {
                            radius: 64
                            spread: 0.1
                            samples: 128
                            color: "#ff6127"
                            visible: true
                        }
                    }

                }
            }
            handle: Image {
                id:handler
                x: control.leftPadding + control.availableWidth / 2 - width / 2
                y:  control.topPadding + control.visualPosition * (control.availableHeight - height)
                source: "qrc:/vsonegx/qml/controls/resource/slider/slider_handler_V.png"
                sourceSize.width:20

                Rectangle{
                    id:activeRec
                    //  anchors.centerIn: handler
                    anchors.centerIn: handler //: handler.verticalCenter
                    x: handler.x  - 3
                    // y:handler.y-3
                    height: 5
                    width: handler.width -1
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
            Timer {
                running: true
              //  repeat: true
                interval: 1000
                onTriggered: {control.value=sliderValue

                }
            }
        }
        Text {
            Layout.alignment: Qt.AlignVCenter

            id: labelText
            text: sliderLabel
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color:Theme.colorText
        }
    }
}
