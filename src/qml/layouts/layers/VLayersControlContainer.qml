import QtQuick
import QtQuick.Layouts
import Theme
import Qt5Compat.GraphicalEffects
import "../../controls"
Rectangle{
    id: vLayersControlContainer
    property int baseWidth: rootAppWindow.winBaseWidth
    property int baseHeight: rootAppWindow.winBaseHeight
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight

    property VLayerControl selectedControl: null

    property alias vPopupInfo: popupInfo.vPopupInfo
    property alias vPopupTimer: popupInfo.vPopupTimer
    property alias vPopupText: popupInfo.vPopupText
    property alias vPopUpItem: popupInfo
    property alias vPopupEmitterControl: popupInfo.emitterControl

    property var itemCoordinates: []
    property var vLayers: []

    color: Theme.colorBackgroundView
    z:-99

    onSelectedControlChanged: {
        rootAppWindow.selectedControlIndex = selectedControl.controlIndex
        rootAppWindow.controlIndexSounds = selectedControl
    }
    VPopup{
        id:popupInfo
        sliderpreferredWidth : 120 * widthScale
        sliderpreferredHeight : 16 *heightScale

    }
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
        id:soundsLayout
        anchors.fill: parent
        anchors.margins: 6
        anchors.topMargin: 8
        columns: 8
        Layout.fillWidth: true
        VLayerControl {
            id: layerControl1
            controlIndex: 0
            Component.onCompleted: {
                vLayersControlContainer.selectedControl = layerControl1
                selected = true
                getChannelSound()
            }
        }
        VLayerControl { id: layerControl2; controlIndex: 1
            Component.onCompleted: {
                getChannelSound()
            }
        }
        VLayerControl { id: layerControl3; controlIndex: 2
            Component.onCompleted: {
                getChannelSound()
            }
        }
        VLayerControl { id: layerControl4; controlIndex: 3
            Component.onCompleted: {
                getChannelSound()
            }
        }
        VLayerControl { id: layerControl5; controlIndex: 4
            Component.onCompleted: {
                getChannelSound()
            }
        }
        VLayerControl { id: layerControl6; controlIndex: 5
            Component.onCompleted: {
                getChannelSound()
            }
        }
        VLayerControl { id: layerControl7; controlIndex: 6
            Component.onCompleted: {
                getChannelSound()
            }
        }
        VLayerControl { id: layerControl8; controlIndex: 7
            Component.onCompleted: {
                getChannelSound()
            }
        }
        VLayerControl { id: layerControl9; controlIndex: 8
            Component.onCompleted: {
                getChannelSound()
            }
        }
        VLayerControl { id: layerControl10; controlIndex: 9
            Component.onCompleted: {
                getChannelSound()
            }
        }
        VLayerControl { id: layerControl11; controlIndex: 10
            Component.onCompleted: {
                getChannelSound()
            }
        }
        VLayerControl { id: layerControl12; controlIndex: 11
            Component.onCompleted: {
                getChannelSound()
            }
        }
        VLayerControl { id: layerControl13; controlIndex: 12
            Component.onCompleted: {
                getChannelSound()
            }
        }
        VLayerControl { id: layerControl14; controlIndex: 13
            Component.onCompleted: {
                getChannelSound()
            }
        }
        VLayerControl { id: layerControl15; controlIndex: 14
            Component.onCompleted: {
                getChannelSound()
            }
        }
        VLayerControl {
            id: layerControl16
            controlIndex: 15
            Component.onCompleted: {
                getChannelSound()
            }
        }

    }

    function storeItemCoordinates() {
        itemCoordinates = [
                    { item: layerControl1, x: layerControl1.x, y: layerControl1.y, right: layerControl1.right, left: layerControl1.left, top: layerControl1.top },
                    { item: layerControl2, x: layerControl2.x, y: layerControl2.y, right: layerControl2.right, left: layerControl2.left, top: layerControl2.top },
                    { item: layerControl3, x: layerControl3.x, y: layerControl3.y, right: layerControl3.right, left: layerControl3.left, top: layerControl3.top },
                    { item: layerControl4, x: layerControl4.x, y: layerControl4.y, right: layerControl4.right, left: layerControl4.left, top: layerControl4.top },
                    { item: layerControl5, x: layerControl5.x, y: layerControl5.y, right: layerControl5.right, left: layerControl5.left, top: layerControl5.top },
                    { item: layerControl6, x: layerControl6.x, y: layerControl6.y, right: layerControl6.right, left: layerControl6.left, top: layerControl6.top },
                    { item: layerControl7, x: layerControl7.x, y: layerControl7.y, right: layerControl7.right, left: layerControl7.left, top: layerControl7.top },
                    { item: layerControl8, x: layerControl8.x, y: layerControl8.y, right: layerControl8.right, left: layerControl8.left, top: layerControl8.top },
                    { item: layerControl9, x: layerControl9.x, y: layerControl9.y, right: layerControl9.right, left: layerControl9.left, top: layerControl9.top },
                    { item: layerControl10, x: layerControl10.x, y: layerControl10.y, right: layerControl10.right, left: layerControl10.left, top: layerControl10.top },
                    { item: layerControl11, x: layerControl11.x, y: layerControl11.y, right: layerControl11.right, left: layerControl11.left, top: layerControl11.top },
                    { item: layerControl12, x: layerControl12.x, y: layerControl12.y, right: layerControl12.right, left: layerControl12.left, top: layerControl12.top },
                    { item: layerControl13, x: layerControl13.x, y: layerControl13.y, right: layerControl13.right, left: layerControl13.left, top: layerControl13.top },
                    { item: layerControl14, x: layerControl14.x, y: layerControl14.y, right: layerControl14.right, left: layerControl14.left, top: layerControl14.top },
                    { item: layerControl15, x: layerControl15.x, y: layerControl15.y, right: layerControl15.right, left: layerControl15.left, top: layerControl15.top },
                    { item: layerControl16, x: layerControl16.x, y: layerControl16.y, right: layerControl16.right, left: layerControl16.left, top: layerControl16.top }
                ]
    }
    function populateVLayers() {
        vLayers = []
        for (var i = 0; i < soundsLayout.children.length; i++) {
            var child = soundsLayout.children[i]
            if (child instanceof VLayerControl) {
                vLayers.push(child)
            }
        }
    }

    Component.onCompleted: {
        storeItemCoordinates()
        populateVLayers()
        console.log("vLayers.length ", vLayers.length)
        console.log("vLayers ", vLayers.map(control => control.id))
        rootAppWindow.vControlLayers = vLayers
        rootAppWindow.vLayersControlContainerGlobal =vLayersControlContainer

    }
    onWidthChanged: {
        storeItemCoordinates()
    }
    onHeightChanged: {
        storeItemCoordinates()
    }

}
