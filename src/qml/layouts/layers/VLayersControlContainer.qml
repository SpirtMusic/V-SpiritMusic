import QtQuick
import QtQuick.Layouts
import "../../controls"
Item{
    id: vLayersControlContainer
    property var selectedControl: null

    GridLayout{
        anchors.fill: parent
        anchors.margins: 3
        anchors.topMargin: 8
        columns: 8
        VLayerControl{}
        VLayerControl{}
        VLayerControl{}
        VLayerControl{}
        VLayerControl{}
        VLayerControl{}
        VLayerControl{}
        VLayerControl{}
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
