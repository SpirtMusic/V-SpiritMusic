import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../layouts"
import "../controls"
SplitView {
    property int baseWidth: rootAppWindow.winBaseWidth
    property int baseHeight: rootAppWindow.winBaseHeight
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight
    property int selectedLayout: 0
    id:voicesViewLayout1
    orientation: Qt.Vertical
    VLayersControlContainer{
        SplitView.fillWidth :true
        z:3
        SplitView.minimumHeight: 120 *heightScale
        SplitView.preferredHeight: 120 *heightScale
    }
    SplitView {
        id:quickSetSplit
        orientation: Qt.Horizontal
        SplitView.preferredHeight: availableHeight
        SplitView.fillHeight: true
        property bool toggled: true

        handle: Rectangle {

            implicitWidth: 4
            implicitHeight: 4
            color: SplitHandle.pressed ? "#a33e19"
                                       : (SplitHandle.hovered ? Qt.lighter("#ff6127", 1.1) : "#ff6127")
            Rectangle {
                width: 30
                height: 16
                anchors.top: parent.top
                anchors.right: parent.right
                color:"#26282a"
                border.color: "#ff6127"
                Text{
                    anchors.fill: parent
                    color:"#ff6127"

                    text:quickSetSplit.toggled ? String.fromCodePoint(0x25B8) :String.fromCodePoint(0x25C2)
                    fontSizeMode: Text.Fit
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            console.log("toggled")
                            if(quickSetSplit.toggled){
                                quickSetSplit.toggled=false

                            }
                            else{
                                quickSetSplit.toggled=true
                            }

                        }
                    }
                }


            }

        }

        Item{
            SplitView.preferredHeight: availableHeight
            Layout.topMargin: 20 *heightScale

            SplitView.preferredWidth: quickSetSplit.toggled ? availableWidth / 2 : availableWidth

            Behavior on SplitView.preferredWidth {
                NumberAnimation {
                    id: animateContentHeight
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
            //  SplitView.preferredWidth:  quickSetSplit.toggled?  availableWidth/2 : 5

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

                    RowLayout{
                        anchors.fill: parent
                        anchors.margins: 15
                        VKnob{
                            knobLabel: "Reverb Depth"
                        }
                        VKnob{
                            knobLabel: "Chorus Depth"
                        }
                        VKnob{
                            knobLabel: "Varl Depth"
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
                        VKnob{
                            knobLabel: "Attack"
                        }
                        VKnob{
                            knobLabel: "Release"
                        }
                    }
                }
                VGroupBox{
                    title: qsTr("Effects")
                    Layout.fillWidth: true
                    Layout.margins: 0
                    Layout.fillHeight: true

                    RowLayout{
                        anchors.fill: parent
                        anchors.margins: 15
                        VKnob{
                            knobLabel: "Reverb Depth"
                        }
                        VKnob{
                            knobLabel: "Chorus Depth"
                        }
                        VKnob{
                            knobLabel: "Varl Depth"
                        }
                    }
                }

            }
        }

    }

}


