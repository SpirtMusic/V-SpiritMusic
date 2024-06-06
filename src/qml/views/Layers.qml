import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../layouts/layers"
import "../controls"
VSplitView {
    property int baseWidth: rootAppWindow.winBaseWidth
    property int baseHeight: rootAppWindow.winBaseHeight
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight
    property bool quickSetSplitToggle: quickSetSplit.toggled
    property real fontScale: Math.max(widthScale, heightScale)
    id:layersView

    orientation: Qt.Vertical
    toggle: false

    VLayersControlContainer{
        SplitView.fillWidth :true
        z:3
        SplitView.minimumHeight: 120 *heightScale
        SplitView.preferredHeight: 120 *heightScale
    }
    VSplitView {
        id:quickSetSplit
        orientation: Qt.Horizontal
        SplitView.preferredHeight: availableHeight
        SplitView.fillHeight: true
        Item{
            SplitView.preferredHeight: availableHeight
            Layout.topMargin: 20 *heightScale

            SplitView.preferredWidth: quickSetSplit.toggled ? availableWidth / 2 : availableWidth

            Behavior on SplitView.preferredWidth {
                NumberAnimation {
                    id: animatePreferredWidth
                    duration: 400
                    easing.type: Easing.OutQuint
                }
            }
            Behavior on SplitView.preferredHeight {
                NumberAnimation {
                    id: animatePreferredHeight
                    duration: 400
                    easing.type: Easing.OutQuint
                }
            }
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 5
                spacing: 1
                VGroupBox{
                    title: qsTr("Upper")
                    Layout.fillWidth: true
                    Layout.margins: 0
                    Layout.fillHeight: true
                    RowLayout{
                        anchors.fill: parent
                        VLayerContainer {
                            selectedLayout:  quickSetSplit.toggled ? 1:0
                        }
                    }
                }
                VGroupBox{
                    title: qsTr("Lower")
                    Layout.fillWidth: true
                    Layout.margins: 0
                    Layout.fillHeight: true
                    RowLayout{
                        anchors.fill: parent
                        VLayerContainer {
                            selectedLayout:  quickSetSplit.toggled ? 1:0
                        }
                    }
                }
                VGroupBox{
                    title: qsTr("Pedal")
                    Layout.fillWidth: true
                    Layout.margins: 0
                    Layout.fillHeight: true
                    RowLayout{
                        anchors.fill: parent
                        VLayerContainer {
                            selectedLayout:  quickSetSplit.toggled ? 1:0

                        }
                    }
                }
            }

        }

        Item{

            SplitView.preferredHeight: availableHeight
            Layout.margins:40

            ColumnLayout{
                visible: quickSetSplit.toggled
                anchors.fill: parent
                anchors.margins: 5
                VGroupBox{
                    title: qsTr("Effects")
                    Layout.fillWidth: true
                    Layout.margins: 0
                    Layout.fillHeight: true

                    GridLayout{
                        anchors.fill: parent
                        anchors.margins: 15
                        columns:4
                        rows:2
                        VKnob{
                            knobLabel: "Reverb Dph"
                        }
                        VKnob{
                            knobLabel: "Chorus Dph"
                        }
                        VKnob{
                            knobLabel: "Varl"
                        }
                        VKnob{
                            knobLabel: "Dph"
                        }

                    }
                }
                VGroupBox{
                    title: qsTr("EG")
                    Layout.fillWidth: true
                    Layout.margins: 0
                    Layout.fillHeight: true

                    RowLayout{
                        anchors.fill: parent
                        anchors.margins: 15
                        VSlider{

                            sliderValue:60
                        }
                        VSlider{

                        }
                        VSlider{
                            sliderValue:77
                        }
                        VSlider{
                            sliderValue:100
                        }
                        VSlider{
                            sliderValue:33
                        }
                        VSlider{
                            sliderValue:70
                        }



                    }
                }


            }
        }


    }

    Item{
        SplitView.preferredHeight: quickSetSplitToggle ?  heightScale :  120*heightScale

        SplitView.fillWidth :true
        VLayersControlContainer{
            anchors.fill: parent
            z:3
            visible:!quickSetSplitToggle
        }
    }

}


