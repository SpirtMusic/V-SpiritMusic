import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Theme
Item{
    id:knobItem
    property int baseWidth: rootAppWindow.winBaseWidth
    property int baseHeight: rootAppWindow.winBaseHeight
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight
    property real fontScale: Math.min(widthScale, heightScale)
    property int knobpreferredHeight: 128
    property int knobpreferredWidth: getknobSize()
    property int knobSize: getknobSize()
    property alias knob: knob
    Layout.preferredHeight: knobpreferredHeight
    Layout.preferredWidth: knobpreferredWidth
    property string knobLabel: "test"
    property string knobUnit: "%"
    function getknobSize(){
    if(rootAppWindow.width>=1920&&rootAppWindow.height>=1080)
        return 128
    else if(rootAppWindow.width>baseWidth&&rootAppWindow.height>baseHeight)
        return 85
    else if(rootAppWindow.width>=baseWidth&&rootAppWindow.height>=baseHeight)
        return 50
    else
        return 50
    }
    ColumnLayout{
        Layout.alignment: Qt.AlignVCenter

        Text {
            Layout.preferredWidth: knobItem.knobpreferredWidth
            id: valueText
            text: Math.trunc(knob.value) + knobUnit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color:Theme.colorText
            font.pointSize: 10 *fontScale
        }
        Dial{
            id: knob
            property string knobType: "LittlePhatty"
            from : 0
            to : 100
            stepSize : 1
            width: knobItem.knobSize
            height: knobItem.knobSize
            Layout.preferredHeight: knobItem.knobSize
            Layout.preferredWidth: knobItem.knobSize

            Behavior on value {
                NumberAnimation {
                    duration: 100
                }
            }
            handle:Item{
            }
            background:

                Image {
                id: knobGraphic
                width: knobItem.knobSize
                height: knobItem.knobSize
                sourceClipRect: knob.getKnobRect(knob.value)
                sourceSize.width : undefined
                sourceSize.height : undefined
                source:"qrc:/vsonegx/qml/controls/resource/knob/"+knob.knobType+"/"+knob.knobType+"_"+knobItem.knobSize+".png"
                // Component.onCompleted: {
                //     let knobSourece="qrc:/vsonegx/qml/controls/resource/knob/"+knob.knobType+"/"+knob.knobType+"_"+knobItem.knobSize+".png"
                //     source=knobSourece
                // }
            }
            function getKnobRect(value) {
                var index = Math.floor(value / (100 / 50)); // Calculate the index based on the value and the number of positions
                var y = index * knobItem.knobSize; // Calculate the y coordinate based on the index and knob size
                return Qt.rect(0, y, knobItem.knobSize, knobItem.knobSize);
            }

        }
        Text {
            Layout.preferredWidth: knobItem.knobpreferredWidth
            id: labelText
            text: knobLabel
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color:Theme.colorText
            font.pointSize: 10 *fontScale
        }
    }

}
