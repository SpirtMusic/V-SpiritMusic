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
                onCountChanged: {
                    if(model.count === 0)
                        currentIndex = -1  // Reset selection when model changes
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
                onCountChanged: {
                    if(model.count === 0)
                        currentIndex = -1  // Reset selection when model changes
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
