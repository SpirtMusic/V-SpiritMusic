import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../layouts"
import "../controls"
SplitView {
    property int baseWidth: rootAppWindow.winBaseWidth
    property int baseHeight: rootAppWindow.winBaseHeight
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight
    orientation: Qt.Vertical
    VLayersControlContainer{
        SplitView.fillWidth :true
        z:3
        SplitView.minimumHeight: 120 *heightScale
        SplitView.preferredHeight: 120 *heightScale
    }
    Item{
        SplitView.preferredHeight: availableHeight
        Layout.topMargin: 20 *heightScale

        SplitView.fillWidth :true
        SplitView.minimumWidth: availableWidth
        ColumnLayout {
            anchors.fill: parent

            spacing: 1
            VGroupBox{
                title: qsTr("Upper")
                Layout.fillWidth: true
                Layout.margins: 0

                Layout.fillHeight: true
                RowLayout{
                    anchors.fill: parent

                    VLayerContainer {

                    }
                }
            }
            VGroupBox{
                title: qsTr("Lower")
                Layout.fillWidth: true
                Layout.margins: 0
                Layout.fillHeight: true
                RowLayout{
                    anchors.fill: parent

                    VLayerContainer {

                    }
                }
            }
            VGroupBox{
                title: qsTr("Pedal")
                Layout.fillWidth: true
                Layout.margins: 0
                Layout.fillHeight: true
                RowLayout{
                    anchors.fill: parent

                    VLayerContainer {

                    }
                }
            }

        }
    }


    Item{
        SplitView.minimumHeight: 120 *heightScale
        SplitView.preferredHeight: 120*heightScale
        SplitView.fillWidth :true
        VLayersControlContainer{
            anchors.fill: parent
            z:3
        }
    }

}

