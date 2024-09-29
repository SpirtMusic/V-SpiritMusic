import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../layouts/layers"
import "../controls"
import com.sonegx.midiclient

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
        SplitView.maximumHeight: 120 * heightScale
    }
    VSplitView {
        id:quickSetSplit
        toggled:false
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
                            layerSetGlobal: MidiClient.Upper
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
                            layerSetGlobal: MidiClient.Lower
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
                            layerSetGlobal: MidiClient.Pedal
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
                        clip:true
                        anchors.margins: 1
                        columns:4
                        rows:2

                        VKnob{
                            id:reverbKnob
                            knobLabel: "Reverb"
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            Connections {
                                target:rootAppWindow
                                function  onSelectedControlIndexChanged(){
                                    reverbKnob.knob.value = sm.getControlReverb(rootAppWindow.selectedControlIndex)

                                }

                            }
                            Connections {
                                target:sm
                                function  onCurrentRegistrationChanged(){
                                    reverbKnob.knob.value = sm.getControlReverb(rootAppWindow.selectedControlIndex)

                                }

                            }
                            Connections{
                                target:reverbKnob.knob
                                function onValueChanged(){
                                    if(reverbKnob.knob.pressed){
                                        sm.setControlReverb(rootAppWindow.selectedControlIndex,reverbKnob.knob.value)
                                        mc.setReverb(rootAppWindow.selectedControlIndex,reverbKnob.knob.value)
                                    }
                                }
                            }

                        }
                        VKnob{
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            knobLabel: "Chorus"
                        }
                        VKnob{
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            knobLabel: "Varl"
                        }
                        VKnob{
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
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
                        anchors.margins: 10

                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.margins: 10

                        ColumnLayout{
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            VSpinBox{
                                id:octaveSpinbBox
                                Layout.preferredHeight: 40
                                Layout.preferredWidth: 120

                                Connections {
                                    target:rootAppWindow
                                    function  onSelectedControlIndexChanged(){
                                        octaveSpinbBox.control.value = sm.getOctave(rootAppWindow.selectedControlIndex)
                                        mc.setOctave(rootAppWindow.selectedControlIndex,octaveSpinbBox.control.value)
                                    }

                                }
                                Connections {
                                    target:sm
                                    function  onCurrentRegistrationChanged(){
                                        octaveSpinbBox.control.value = sm.getOctave(rootAppWindow.selectedControlIndex)
                                    }

                                }
                                Connections{
                                    target:octaveSpinbBox.control
                                    function onValueChanged(){
                                        mc.setOctave(rootAppWindow.selectedControlIndex,octaveSpinbBox.control.value)
                                        sm.saveOctave(rootAppWindow.selectedControlIndex,octaveSpinbBox.control.value)
                                        mc.sendAllNotesOff()

                                    }
                                }
                                Component.onCompleted: {
                                    octaveSpinbBox.control.value = sm.getOctave(rootAppWindow.selectedControlIndex)
                                    mc.setOctave(rootAppWindow.selectedControlIndex,octaveSpinbBox.control.value)

                                }
                            }
                            Item{}
                            Item{}
                            Item{ Layout.fillHeight: true}
                            VMidiRange{
                                Connections {
                                    target:mc
                                    function  onNoteRangeChanged(){
                                        var chRange= mc.channelRanges
                                        var lNote=chRange[rootAppWindow.selectedControlIndex].lowNote
                                        var hNote=chRange[rootAppWindow.selectedControlIndex].highNote
                                        console.log("LLLLL NOTE : ",lNote )
                                        console.log("HHHH NOTE : ", hNote)
                                        sm.saveChannelRange(rootAppWindow.selectedControlIndex,lNote,hNote)
                                    }
                                }
                                Connections {
                                    target:rootAppWindow
                                    function  onSelectedControlIndexChanged(){
                                        mc.setCurrentChannel(rootAppWindow.selectedControlIndex)
                                        var range = sm.getChannelRange(rootAppWindow.selectedControlIndex);
                                        mc.setChannelRange(rootAppWindow.selectedControlIndex,range.lowNote,range.highNote);
                                    }

                                    // onIsFlashingChanged: {
                                    //     if(!mc.capturingHighNote){
                                    //             var chRange= mc.channelRanges()
                                    //                 var hNote=chRange[]
                                    //     }

                                    // }
                                }
                                Connections {
                                    target:sm
                                    function  onCurrentRegistrationChanged(){
                                        mc.setCurrentChannel(rootAppWindow.selectedControlIndex)
                                        var range = sm.getChannelRange(rootAppWindow.selectedControlIndex);
                                        mc.setChannelRange(rootAppWindow.selectedControlIndex,range.lowNote,range.highNote);
                                    }

                                }
                                Component.onCompleted: {
                                    // Retrieve the range for channel 1
                                    var range = sm.getChannelRange(rootAppWindow.selectedControlIndex);
                                    console.log("Low Note: " + range.lowNote);
                                    console.log("High Note: " + range.highNote);
                                    mc.setChannelRange(rootAppWindow.selectedControlIndex,range.lowNote,range.highNote);

                                }


                            }
                            Item{ Layout.fillHeight: true}
                        }
                        // RowLayout{
                        //     anchors.margins: 10
                        //     Layout.fillHeight: true
                        //     Layout.fillWidth: true
                        //     VSlider{
                        //         id:masterVolumeSLider
                        //         sliderLabel:"Master Volume"
                        //         sliderValue: mc.masterVolume
                        //         Connections{
                        //             target: masterVolumeSLider.control
                        //             function onValueChanged(){
                        //                 if (masterVolumeSLider.control.value !== mc.masterVolume && masterVolumeSLider.control.pressed) {
                        //                     mc.setMasterVolume(masterVolumeSLider.control.value)
                        //                     console.log(masterVolumeSLider.control.value)
                        //                 }
                        //             }
                        //         }
                        //         Connections{
                        //             target: mc
                        //             function onMasterVolumeChanged(){
                        //                 if (mc.masterVolume !== masterVolumeSLider.sliderValue && !masterVolumeSLider.control.pressed) {
                        //                     masterVolumeSLider.sliderValue = mc.masterVolume
                        //                 }
                        //             }
                        //         }
                        //     }


                        // }

                    }
                }


            }
        }


    }

    Item{
        SplitView.preferredHeight: quickSetSplitToggle ?  heightScale :  120*heightScale
        SplitView.fillWidth :true
        VLayerRegistraions{
            anchors.fill: parent
            z:3
            visible:!quickSetSplitToggle
        }
    }
}


