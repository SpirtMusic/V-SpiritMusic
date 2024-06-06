import QtQuick
import QtQuick.Layouts
import Theme
import Qt5Compat.GraphicalEffects
import "../../controls"
Rectangle{
    id: vLayersControlContainer
    property var selectedControl: null
    color: Theme.colorBackgroundView
    z:-99
    Image {
        id: mask
        source: "qrc:/vsonegx/qml/controls/resource/texture/tx3.jpg"
       // sourceSize: Qt.size(parent.width, parent.height)
        smooth: true
        visible: false
    }

    OpacityMask {
        anchors.fill: parent
        source: mask
        maskSource: mask
    }
    GridLayout{
        anchors.fill: parent
        anchors.margins: 6
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
