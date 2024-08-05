import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Theme
import "../../../controls"
Item {
    property int baseWidth: rootAppWindow.winBaseWidth
    property int baseHeight: rootAppWindow.winBaseHeight
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight
    property real fontScale: Math.min(widthScale, heightScale)
    ColumnLayout{
        id:channelsLayout
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
                            font.pixelSize: 12*fontScale
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
                        font.pixelSize: 12*fontScale
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
                        font.pixelSize: 12*fontScale
                        color:  Theme.colorText
                    }
                    Text {
                        Layout.alignment: Qt.AlignRight
                        text: mc.isOutputPortConnected ? "Connected" : "Disconnected"
                        font.pixelSize: 12*fontScale
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
                columns: 3
                rows:1
                RowLayout{
                    Text {
                        id: ch1
                        text: qsTr("Channel 1: ")
                        font.pixelSize: 12*fontScale
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
                        font.pixelSize: 12*fontScale
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
                RowLayout{
                    Text {
                        id: ch3
                        text: qsTr("Channel 3: ")
                        font.pixelSize: 12*fontScale
                        color:  Theme.colorText

                    }
                    VChannelIndicator{
                        id:ch3_idicator
                        color:Theme.colorStandby
                    }
                    Timer {
                        id: channel3Timer
                        interval: 60
                        onTriggered: ch3_idicator.color=Theme.colorStandby
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
                        else if (channel === 2) {
                            ch3_idicator.color = Theme.colorActive
                            channel3Timer.restart()
                        }
                    }
                }
            }
        }
    }
    ColumnLayout{
        id:rawOutputsLayout
        anchors.top: parent.top
        anchors.left: channelsLayout.right
        anchors.right:parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 5

        width: parent.width/2
        VGroupBox{
            title: qsTr("Raw outputs")
            collapsable: false
            Layout.fillWidth: true
            Layout.fillHeight: true
            ColumnLayout{
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right:parent.right
                anchors.margins: 20
                spacing: 20
                VCheckBox{
                    id:cc1
                    text: "Send CC from VSpiritMusic"
                    onCheckedChanged: {
                        sm.saveRawOutputCCEnabled(1,cc1.checked)
                        mc.setCc(cc1.checked)
                    }
                    Component.onCompleted:{
                        checked = sm.getRawOutputCCEnabled(1);
                        mc.setCc(checked)
                    }
                }
                VCheckBox{
                    id:pc1
                    text: "Send PC from VSpiritMusic"
                    onCheckedChanged: {
                        sm.saveRawOutputPCEnabled(1,pc1.checked)
                        mc.setPc(pc1.checked)
                    }
                    Component.onCompleted:{
                        checked = sm.getRawOutputPCEnabled(1);
                        mc.setPc(checked)
                    }
                }
                Label{
                    text: "Channel"
                    font.pixelSize: 12*fontScale
                }
                VComboBox{
                    id:rawOutputsChannels
                    model: ListModel {
                         id: channelsModel
                         Component.onCompleted: {
                             for (let i = 1; i <= 16; i++) {
                                 append({name: i.toString()});
                             }
                             append({name: "ALL"});
                         }
                     }
                    onCurrentIndexChanged: {
                        var selectedValue = model.get(currentIndex).name
                        var valueToSave;

                        if (selectedValue === "ALL") {
                            valueToSave = 17;
                        } else {
                            valueToSave = parseInt(selectedValue, 10);
                        }

                        console.log("Selected value:", selectedValue, "Value to save:", valueToSave);
                        sm.saveRawOutputChannel(1, valueToSave);
                    }
                }
            }

        }
    }

}

