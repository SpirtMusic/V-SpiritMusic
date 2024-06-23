import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Theme
import "../../../controls"
Item {
    ColumnLayout{
        anchors.top: parent.top
        anchors.left: parent.left
        //anchors.bottom: parent.bottom
        anchors.margins: 20

        width: parent.width/2
        spacing: 30
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
        VButton{
            // Layout.alignment: Qt.AlignHCenter
            text: "Connect"
           // onClicked: mc.getIOPorts()
        }
    }
}
