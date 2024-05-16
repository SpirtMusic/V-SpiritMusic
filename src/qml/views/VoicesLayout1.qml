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
        orientation: Qt.Horizontal
        SplitView.preferredHeight: availableHeight
        SplitView.fillHeight: true
        handle: Rectangle {
            implicitWidth: 2
            implicitHeight: 2
            color: SplitHandle.pressed ? "#ff6127"
                                       : (SplitHandle.hovered ? Qt.lighter("#ff8d3c", 1.1) : "#ff8d3c")
        }
        Item{
            SplitView.preferredHeight: availableHeight
            Layout.topMargin: 20 *heightScale
            SplitView.minimumWidth: availableWidth /2
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
                            selectedLayout: voicesViewLayout1.selectedLayout
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
                            selectedLayout: voicesViewLayout1.selectedLayout
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
                            selectedLayout: voicesViewLayout1.selectedLayout

                        }
                    }
                }
            }
        }

        Item{
            SplitView.preferredHeight: availableHeight
            Layout.margins:40
            ColumnLayout{
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


