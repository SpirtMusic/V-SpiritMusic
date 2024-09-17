import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "."
import Theme
Item {
    RowLayout {
        spacing: 5
        VButton {
            text: "Low Note"
            highlighted: mc.capturingLowNote
            isFlashing: mc.capturingLowNote
            onClicked: mc.capturingLowNote = !mc.capturingLowNote
        }
        Text {
            id: rangeInput
            // readOnly: true
            text: mc.noteRange
            // placeholderText: "Low-High"
            color :Theme.colorText
            width: 40
        }

        VButton {
            text: "High Note"
            highlighted: mc.capturingHighNote
            isFlashing: mc.capturingHighNote
            onClicked: mc.capturingHighNote = !mc.capturingHighNote
        }
    }
}
