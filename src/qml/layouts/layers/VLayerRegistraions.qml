import QtQuick
import QtQuick.Layouts
import Theme
import "../../controls"

ColumnLayout {
    anchors.fill: parent
    anchors.margins: 20
    anchors.topMargin: 10
    RowLayout{
        Layout.fillWidth: true
        Item{
            Layout.fillWidth: true
        }
        VButton{
            text:"RESET"
            onClicked: {
                mc.sendAllNotesOff()
            }

        }
    }
    RowLayout{
        Layout.fillWidth: true
        spacing: 8
        VMemoryButton{
            text:"MEMORY"
            Layout.alignment: Qt.AlignLeft  // Align the button to the left
            onClicked: {
                sm.saveRegistration()
            }
        }
        Item{
            Layout.fillWidth: true
        }
        VRegistrationsList{
            Layout.fillWidth: true          // Make the registrations list fill the available width
        }
        Item{
            Layout.fillWidth: true
        }
    }

}
