import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Theme
import "../../../controls"
Item {
    ColumnLayout{
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 5

        width: parent.width/2
        VGroupBox{
            title: qsTr("Midi Connections")
            collapsable: false
            Layout.fillWidth: true
            Layout.fillHeight: true
            ColumnLayout{
                anchors.fill: parent
                anchors.margins: 20
                spacing: 20
                ColumnLayout{
                    //Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    spacing: 10
                    RowLayout{
                        Label{
                            Layout.fillWidth: true
                            text: "Input"
                        }
                        VButton{
                            // Layout.alignment: Qt.AlignHCenter
                            text: "Refresh"
                            onClicked: mc.getIOPorts()
                            iconSource: "qrc:/vsonegx/qml/imgs/icon-refresh.svg"

                        }
                    }
                    VComboBox{
                        id:inputs
                        Layout.fillWidth: true
                        model: mc.inputPorts
                        textRole: "name"
                        onModelChanged: {
                            var savedName = sm.loadSelectedInput()
                            for (var i = 0; i < model.rowCount(); i++) {
                                console.log("model.data(model.index(i, 0), Qt.UserRole + 1) " +model.data(model.index(i, 0), Qt.UserRole + 1))
                                if (model.data(model.index(i, 0), Qt.UserRole + 1) === savedName) {
                                    currentIndex = i
                                    return
                                }
                            }
                            currentIndex = -1  // If saved name not found
                        }
                        onCurrentIndexChanged: {
                            if (currentIndex >= 0) {
                                var currentName =  model.data(model.index(currentIndex, 0), Qt.UserRole + 1)
                                sm.saveSelectedInput(currentName)
                            }
                        }
                    }
                }
                ColumnLayout{
                    // Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    spacing: 10
                    Label{
                        text: "Output"
                    }
                    VComboBox{
                        id:outputs
                        Layout.fillWidth: true
                        model: mc.outputPorts
                        textRole: "name"
                        onModelChanged: {

                            var savedName = sm.loadSelectedOutput()
                            for (var i = 0; i < model.rowCount(); i++) {
                                if (model.data(model.index(i, 0), Qt.UserRole + 1) === savedName) {
                                    currentIndex = i
                                    return
                                }
                            }
                            currentIndex = -1  // If saved name not found
                        }
                        onCurrentIndexChanged: {
                            if (currentIndex >= 0) {
                                var currentName =  model.data(model.index(currentIndex, 0), Qt.UserRole + 1)

                                sm.saveSelectedOutput(currentName)
                            }
                        }
                    }
                }
                RowLayout{
                    Layout.fillWidth: true

                    VButton{
                        Layout.alignment: Qt.AlignLeft
                        id:connectBtn
                        text: "Connect"
                        onClicked: {
                            mc.makeDisconnect()
                            disconnectTimer.start()
                        }
                        function connect(){
                            var inputPort = inputs.model.data(inputs.model.index(inputs.currentIndex, 0), Qt.UserRole + 2)
                            var outputPort = outputs.model.data(outputs.model.index(outputs.currentIndex, 0), Qt.UserRole + 2)
                            mc.makeConnection(inputPort, outputPort)
                        }

                    }
                    Timer {
                        id: disconnectTimer
                        interval: 1000
                        repeat: false
                        onTriggered: {
                            connectBtn.connect()
                        }
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    Text {
                        text:  "Status : "
                        color:  Theme.colorText
                    }
                    Text {
                        Layout.alignment: Qt.AlignRight
                        text: mc.isOutputPortConnected ? "Connected" : "Disconnected"
                        color: mc.isOutputPortConnected ? "#55ff00" : "#ff0000"
                    }
                }
            }
        }
        VGroupBox{
            title: qsTr("Midi Channels")
            collapsable: false
            Layout.fillWidth: true
            Layout.fillHeight: true
            GridLayout{
                anchors.fill: parent
                anchors.margins: 20
                columns: 2
                rows:1
                RowLayout{
                    Text {
                        id: ch1
                        text: qsTr("Channel 1: ")
                        color:  Theme.colorText
                    }
                    VChannelIndicator{
                        id:ch1_idicator
                        color:Theme.colorStandby
                    }
                    Timer {
                           id: channel0Timer
                           interval: 60
                           onTriggered: ch1_idicator.color=Theme.colorStandby
                       }
                }
                RowLayout{
                    Text {
                        id: ch2
                        text: qsTr("Channel 2: ")
                        color:  Theme.colorText
                    }
                    VChannelIndicator{
                        id:ch2_idicator
                        color:Theme.colorStandby
                    }
                    Timer {
                           id: channel1Timer
                           interval: 60
                           onTriggered: ch2_idicator.color=Theme.colorStandby
                       }
                }
                Connections{
                target: mc
                function onChannelActivated(channel){
                    if (channel === 0) {
                              ch1_idicator.color = Theme.colorActive
                              channel0Timer.restart()
                          } else if (channel === 1) {
                              ch2_idicator.color = Theme.colorActive
                              channel1Timer.restart()
                          }
                }
                }
            }
        }
    }
}

