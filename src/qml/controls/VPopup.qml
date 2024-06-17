import QtQuick
import QtQuick.Controls
import "."
Item {
    id:vPopup

    property alias vPopupInfo: vPopupInfo
    property alias vPopupTimer: vPopupTimer
    property alias sliderPopupH: sliderPopupH
    property int vPopupText: 0
    property int  sliderpreferredWidth: 0
    property int  sliderpreferredHeight:0
    property bool controlPressed: false
    Popup {
        id: vPopupInfo
        width: sliderpreferredWidth
        modal: false
        focus: false
        visible:false
        contentItem: VSliderPopupH {
            id:sliderPopupH
            sliderValue: vPopup.vPopupText
            sliderpreferredWidth:vPopup.sliderpreferredWidth
            sliderpreferredHeight:vPopup.sliderpreferredHeight

        }
        exit: Transition {
            // Animation when the popup is hidden
            NumberAnimation {
                property: "opacity"
                from: 1.0
                to: vPopupTimer.running ? 1.0 : 0.0
                duration: 300
            }
        }

    }
    Timer {
        id: vPopupTimer
        interval: 3000
        running: false
        repeat: false
        onTriggered: {
            if (!sliderPopupH.control.pressed) {
                vPopupInfo.close()
            }
        }
    }

    Timer {
        id: controlPressCheckTimer
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            if (controlPressed !== sliderPopupH.control.pressed) {
                controlPressed = sliderPopupH.control.pressed;
            }
        }
    }
    onControlPressedChanged: {
        if (controlPressed) {
            vPopupTimer.stop()
        } else {
            vPopupTimer.restart()
        }
    }
    function getX(soundItem) {

        var index = getItemIndex(soundItem)

        if (index !== -1) {
            var paddingItem=getPadding(index,soundItem)

            x =paddingItem //( vLayersControlContainer.itemCoordinates[index].x -(sliderpreferredWidth - soundItem.width -(35 * widthScale) ) / 2)
        } else {
            console.warn("Item not found in itemCoordinates array")
        }
    }
    function getPadding(index,soundItem){
        if (index===7||index===15){
            return ( vLayersControlContainer.itemCoordinates[index].x - (sliderpreferredWidth - soundItem.width ))
        }
        if (index===0||index===8){
            return ( vLayersControlContainer.itemCoordinates[index].x -(sliderpreferredWidth - soundItem.width - (35* widthScale ) ) / 2)
        }
        else {
            return ( vLayersControlContainer.itemCoordinates[index].x -(sliderpreferredWidth - soundItem.width ) / 2)
        }

    }

    function getY(soundItem) {
        var index = getItemIndex(soundItem)
        if (index !== -1) {
            y = vLayersControlContainer.itemCoordinates[index].y - sliderpreferredHeight
        } else {
            console.warn("Item not found in itemCoordinates array")
        }
    }

    function getItemIndex(soundItem) {
        for (var i = 0; i < vLayersControlContainer.itemCoordinates.length; i++) {
            if (vLayersControlContainer.itemCoordinates[i].item === soundItem) {
                return i
            }
        }
        return -1
    }

}
