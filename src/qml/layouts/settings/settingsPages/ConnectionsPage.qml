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
            Label{
                text: "Input"
            }
            VComboBox{
                      Layout.fillWidth: true
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
                      Layout.fillWidth: true
            }
        }
        VButton{
           // Layout.alignment: Qt.AlignHCenter
            text: "Connect"
        }
    }
}
