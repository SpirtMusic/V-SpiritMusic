import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle{
    id:layerControl
    property int baseWidth: rootAppWindow.winBaseWidth
    property int baseHeight: rootAppWindow.winBaseHeight
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight
    property color textColor: "#ffffff"
    property color iconColor: "#ffffff"
    property color backgroundColor: "#41474d"
    property color selectColor: "#ff6127"
    property string voiceName: "voice name"
    property bool selected: false

    color:backgroundColor
    border.color: selected ? selectColor : backgroundColor
    radius: 4
    height: 50 * heightScale
    width: 95 * widthScale

    Rectangle{
        color: layerControl.backgroundColor
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 2
        anchors.topMargin: 2
        anchors.rightMargin: 2
        height: parent.height/2
        Rectangle{
            height: parent.height
            width: 30 * widthScale
            anchors.left: parent.left
            anchors.top:parent.top
            color:layerControl.backgroundColor
            z:2
            MouseArea {
                property real previousPosition: 0
                property real direction: 0
                property real swipeDistance: 0
                property real swipeThreshold: 5  // Minimum swipe distance required
                property real swipeSensitivity: 1  // Adjust this value to control the sensitivity
                property int pressInterval: 30
                property Timer pressTimer: Timer {
                    interval: parent.pressInterval
                    repeat: true
                    onTriggered: voiceControl.decrease()
                }
                anchors.fill: parent;
                onPressed: {
                    previousPosition = mouseX;
                    direction = 0;
                    console.debug("onPressed mouseX:" + mouseX);
                    parent.color= "#e4e4e4";
                    swipeDistance = 0
                    pressTimer.start()
                }
                onPositionChanged: {
                    if (!containsMouse) {
                        pressTimer.stop()
                    }
                    if (previousPosition < mouseX) {
                        direction = 1  // Swipe to the right
                        swipeDistance += mouseX - previousPosition
                    } else if (previousPosition > mouseX) {
                        direction = -1  // Swipe to the left
                        swipeDistance += previousPosition - mouseX
                    } else {
                        direction = 0
                    }

                    if (Math.abs(swipeDistance) >= swipeThreshold) {
                        let increments = swipeDistance / swipeSensitivity
                        if (direction > 0) {
                            voiceControl.value += increments * voiceControl.stepSize
                        } else if (direction < 0) {
                            voiceControl.value -= Math.abs(increments) * voiceControl.stepSize
                        }
                        swipeDistance = 0  // Reset swipeDistance after updating the value
                    }
                    previousPosition = mouseX
                }

                onReleased: {
                    parent.color= "#41474d";
                    if(direction > 0){
                        console.debug("swipe to right");
                    }
                    else if(direction < 0){
                        console.debug("swipe to left");
                    }
                    else{
                        console.debug("swipe no detected");
                        voiceControl.decrease()
                    }
                    pressTimer.stop()
                }

            }
            Text {
                text: "-"
                font.pixelSize: voiceControl.font.pixelSize * 2
                color: "#ff6127"
                anchors.fill: parent
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
        SpinBox {
            id: voiceControl
            anchors.top:parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height
            width: parent.width/3.5 * widthScale
            value: 50
            to:100

            up.indicator:Item{
                visible: false
            }
            down.indicator:Item{
                visible: false
            }
            background:Rectangle{

                visible:false
            }
            contentItem: Rectangle {
                anchors.fill: parent
                color: layerControl.backgroundColor

                Text {
                    anchors.centerIn: parent
                    z: 2
                    text: voiceControl.textFromValue(voiceControl.value, voiceControl.locale)
                    color: layerControl.textColor
                }
                MouseArea {
                    property real previousPosition: 0
                    property real direction: 0
                    property real swipeDistance: 0
                    property real swipeThreshold: 5  // Minimum swipe distance required
                    property real swipeSensitivity: 1  // Adjust this value to control the sensitivity
                    z:-1

                    anchors.fill: parent;
                    onPressed: {
                        previousPosition = mouseX;
                        direction = 0;
                        console.debug("onPressed mouseX:" + mouseX);
                        swipeDistance = 0

                    }
                    onPositionChanged: {

                        if (previousPosition < mouseX) {
                            direction = 1  // Swipe to the right
                            swipeDistance += mouseX - previousPosition
                        } else if (previousPosition > mouseX) {
                            direction = -1  // Swipe to the left
                            swipeDistance += previousPosition - mouseX
                        } else {
                            direction = 0
                        }

                        if (Math.abs(swipeDistance) >= swipeThreshold) {
                            let increments = swipeDistance / swipeSensitivity
                            if (direction > 0) {
                                voiceControl.value += increments * voiceControl.stepSize
                            } else if (direction < 0) {
                                voiceControl.value -= Math.abs(increments) * voiceControl.stepSize
                            }
                            swipeDistance = 0  // Reset swipeDistance after updating the value
                        }
                        previousPosition = mouseX
                    }

                    onReleased: {
                        if(direction > 0){
                            console.debug("swipe to right");
                        }
                        else if(direction < 0){
                            console.debug("swipe to left");
                        }
                        else{
                            if (vLayersControlContainer.selectedControl) {
                                vLayersControlContainer.selectedControl.selected = false
                            }
                            vLayersControlContainer.selectedControl = layerControl
                            layerControl.selected = true
                        }
                    }

                }
            }

        }
        Rectangle{

            height: parent.height
            width: 30 * widthScale
            anchors.right: parent.right
            anchors.top:parent.top
            color:layerControl.backgroundColor
            MouseArea {

                property real previousPosition: 0
                property real direction: 0
                property real swipeDistance: 0
                property real swipeThreshold: 5  // Minimum swipe distance required
                property real swipeSensitivity: 1  // Adjust this value to control the sensitivity
                property int pressInterval: 30
                property Timer pressTimer: Timer {
                    interval: parent.pressInterval
                    repeat: true
                    onTriggered: voiceControl.increase()
                }
                anchors.fill: parent;
                onPressed: {
                    previousPosition = mouseX;
                    direction = 0;
                    console.debug("onPressed mouseX:" + mouseX);
                    parent.color= "#e4e4e4";
                    swipeDistance = 0
                    pressTimer.start()
                }
                onPositionChanged: {
                    if (!containsMouse) {
                        pressTimer.stop()
                    }
                    if (previousPosition < mouseX) {
                        direction = 1  // Swipe to the right
                        swipeDistance += mouseX - previousPosition
                    } else if (previousPosition > mouseX) {
                        direction = -1  // Swipe to the left
                        swipeDistance += previousPosition - mouseX
                    } else {
                        direction = 0
                    }

                    if (Math.abs(swipeDistance) >= swipeThreshold) {
                        let increments = swipeDistance / swipeSensitivity
                        if (direction > 0) {
                            voiceControl.value += increments * voiceControl.stepSize
                        } else if (direction < 0) {
                            voiceControl.value -= Math.abs(increments) * voiceControl.stepSize
                        }
                        swipeDistance = 0  // Reset swipeDistance after updating the value
                    }
                    previousPosition = mouseX
                }

                onReleased: {
                    parent.color= "#41474d";
                    if(direction > 0){
                        console.debug("swipe to right");
                    }
                    else if(direction < 0){
                        console.debug("swipe to left");
                    }
                    else{
                        console.debug("swipe no detected");
                        voiceControl.increase()
                    }
                    pressTimer.stop()
                }

            }
            Text {
                text: "+"
                font.pixelSize: voiceControl.font.pixelSize * 2
                color: "#ff6127"
                anchors.fill: parent
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

    }
    Text {
        width: parent.width
        anchors.bottom:parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 2
        anchors.bottomMargin: 2
        anchors.rightMargin: 2
        color: layerControl.textColor
        text: layerControl.voiceName
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
    MouseArea {
        property real previousPosition: 0
        property real direction: 0
        property real swipeDistance: 0
        property real swipeThreshold: 5  // Minimum swipe distance required
        property real swipeSensitivity: 1  // Adjust this value to control the sensitivity
        z:-1

        anchors.fill: parent;
        onPressed: {
            previousPosition = mouseX;
            direction = 0;
            console.debug("onPressed mouseX:" + mouseX);
            swipeDistance = 0

        }
        onPositionChanged: {

            if (previousPosition < mouseX) {
                direction = 1  // Swipe to the right
                swipeDistance += mouseX - previousPosition
            } else if (previousPosition > mouseX) {
                direction = -1  // Swipe to the left
                swipeDistance += previousPosition - mouseX
            } else {
                direction = 0
            }

            if (Math.abs(swipeDistance) >= swipeThreshold) {
                let increments = swipeDistance / swipeSensitivity
                if (direction > 0) {
                    voiceControl.value += increments * voiceControl.stepSize
                } else if (direction < 0) {
                    voiceControl.value -= Math.abs(increments) * voiceControl.stepSize
                }
                swipeDistance = 0  // Reset swipeDistance after updating the value
            }
            previousPosition = mouseX
        }

        onReleased: {
            if(direction > 0){
                console.debug("swipe to right");
            }
            else if(direction < 0){
                console.debug("swipe to left");
            }
            else{
                if (vLayersControlContainer.selectedControl) {
                    vLayersControlContainer.selectedControl.selected = false
                }
                vLayersControlContainer.selectedControl = layerControl
                layerControl.selected = true
            }
        }

    }
}

