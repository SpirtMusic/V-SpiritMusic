import QtQuick
import QtQuick.Layouts
import "../controls"
Item{
    id: vLayersControlContainer
    property var selectedControl: null  // Property to track the selected control

    Column{
        spacing: 10
        anchors.centerIn: parent
        Row{

            spacing: 5
            VLayerControl{}
            VLayerControl{}
            VLayerControl{}
            VLayerControl{}
            VLayerControl{}
            VLayerControl{}
            VLayerControl{}
            VLayerControl{}
        }

        Row{

            spacing: 5
            VLayerControl{}
            VLayerControl{}
            VLayerControl{}
            VLayerControl{}
            VLayerControl{}
            VLayerControl{}
            VLayerControl{}
            VLayerControl{}

        }
    }

}
