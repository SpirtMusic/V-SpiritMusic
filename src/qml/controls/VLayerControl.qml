import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Theme
Rectangle{
    id:layerControl
    property int baseWidth: rootAppWindow.winBaseWidth
    property int baseHeight: rootAppWindow.winBaseHeight
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight
    property real fontScale: Math.min(widthScale, heightScale)

    property color textColor: Theme.colorText
    property color iconColor: Theme.colorText
    property color backgroundColor: Theme.colorButtonBackground
    property color selectColor: Theme.colorSelect
    property int controlIndex: 0

    property string voiceName: "voice name"
    property string chCategory: "Category name"
    property bool chIsInMain: false
    property string chMainCategory: ""
    property int chCatgeoryIndex: -1
    property int chSoundIndex: -1

    property bool selected: false
    property bool firstLaunch : true
    property int spinBoxValue: 0
    color:Theme.colorBackgroundView
    border.color: selected ? selectColor : backgroundColor
    onVoiceNameChanged: {
        if(selected && !firstLaunch)
            sm.saveChannelSound(controlIndex,chIsInMain,chMainCategory,chCatgeoryIndex,chSoundIndex)
    }

    radius: 4
    height: 50 * heightScale
    width: 90 * widthScale
    Layout.preferredWidth: width
    Layout.preferredHeight: height
    layer.enabled: true
    layer{
        effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 1
            verticalOffset: 1
        }
    }

    Image {
        id: mask
        source: "qrc:/vsonegx/qml/controls/resource/texture/button_texture.png"
        // sourceSize: Qt.size(parent.width, parent.height)
        smooth: true
        visible: false
    }

    OpacityMask {
        anchors.fill: parent
        source: mask
        z:99
        // opacity: 0.5
        maskSource: mask
    }


    gradient: Gradient {
        GradientStop { position: 0.0; color:  "#527eb5ff"}
        GradientStop { position: 0.55; color: backgroundColor }
        GradientStop { position: 1.0; color: backgroundColor }
    }
    Text {
        text: controlIndex + 1
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: voiceControl.font.pixelSize * 0.5
        anchors.bottom: parent.bottom
        // anchors.fill:parent
        font.pixelSize: voiceControl.font.pixelSize * 1.1
        color: textColor
        font.bold: true
        fontSizeMode: Text.Fit
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        z:99
        opacity: 0.3
    }
    Rectangle{
        color: layerControl.backgroundColor
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 2
        anchors.topMargin: 2
        anchors.rightMargin: 2
        height: parent.height/2
        // z:99
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
                    parent.color= Theme.colorButtonBackground;
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
                z:99
            }
        }
        SpinBox {
            id: voiceControl
            anchors.top:parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height
            width: parent.width/3.5 * widthScale
            value:20// spinBoxValue
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
                    font.pointSize: 10 *fontScale
                    z: 99
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
                    onDoubleClicked: {
                        if (vLayersControlContainer.selectedControl) {
                            vLayersControlContainer.selectedControl.selected = false
                        }
                        vLayersControlContainer.selectedControl = layerControl
                        layerControl.selected = true
                        rootAppWindow.globalTabIndex=1
                    }

                }
            }
            onValueChanged:{
                vLayersControlContainer.vPopupInfo.open()
                vLayersControlContainer.vPopupText = voiceControl.value
                vLayersControlContainer.vPopupTimer.restart()
                vLayersControlContainer.vPopUpItem.getX(layerControl)
                vLayersControlContainer.vPopUpItem.getY(layerControl)
                vLayersControlContainer.vPopupEmitterControl=voiceControl
                sm.setControlVolume(controlIndex,value)
                mc.setVolume(controlIndex,value)
            }
            Component.onCompleted: {
                value=sm.getControlVolume(controlIndex)

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
                    parent.color=Theme.colorButtonBackground;
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
                z:99
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
        font.pointSize: 10 *fontScale
        z:99
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
        onDoubleClicked: {
            if (vLayersControlContainer.selectedControl) {
                vLayersControlContainer.selectedControl.selected = false
            }
            vLayersControlContainer.selectedControl = layerControl
            layerControl.selected = true
            rootAppWindow.globalTabIndex=1
        }


    }
    Rectangle {
        id:glowRec
        anchors.fill: parent
        color:"transparent"
        border.color:  selected ? selectColor :Theme.colorButtonBackground
        z:9999
    }
    Glow {
        anchors.fill: glowRec
        radius: 64
        spread: 0.5
        samples: 128
        color:selectColor
        source: glowRec
        visible: selected
    }
    Component.onCompleted:{

    }
    function getChannelSound(){

        var channelInfo = sm.getChannelSound(controlIndex)
        // console.log("mainCategory ",channelInfo.mainCategory)
        // console.log("isInMain ",channelInfo.isInMain)
        // console.log("soundIndex ",channelInfo.soundIndex)
        var catgeoryIndex = channelInfo.categoryIndex
        var isMainCategory = channelInfo.isInMain
        var selectedSoundIndex = channelInfo.soundIndex
        var soundModel
        var currentCategoryMain = channelInfo.mainCategory
        var categoryName=""

        if(isMainCategory)
            categoryName= sm.getSubCategories(currentCategoryMain)
        else
            categoryName= sm.getCategories()

        var currentCategory =""
        currentCategory=categoryName[channelInfo.categoryIndex]

        if(currentCategoryMain==""){
            if (currentCategory !== "") {
                soundModel = sm.getSoundsForCategory(currentCategory)
            } else {
                soundModel = []
            }
        }
        else{
            if (currentCategory !== "") {
                soundModel = sm.getSoundsForSubCategory(currentCategoryMain,currentCategory)
            } else {
                soundModel = []
            }
        }
        var soundDetails= currentCategoryMain!=""?
                    sm.getSoundSubDetails(currentCategoryMain,currentCategory, soundModel[selectedSoundIndex]):
                    sm.getSoundDetails(currentCategory, soundModel[selectedSoundIndex])
        if(soundDetails !== undefined){
            var pc_value=soundDetails.pc

            if(rootAppWindow.currentCategoryLevel==1){
                pc_value=pc_value-1
            }
            mc.sendMsbLsbPc(controlIndex,soundDetails.msb,soundDetails.lsb,pc_value)
            voiceName=soundDetails.name
        }
        if(currentCategory!==undefined)
            chCategory= currentCategory
        if(isMainCategory!==undefined)
            chIsInMain= isMainCategory
        if(currentCategoryMain!==undefined)
            chMainCategory= currentCategoryMain
        if(catgeoryIndex!==undefined)
            chCatgeoryIndex= catgeoryIndex
        if(selectedSoundIndex!==undefined)
            chSoundIndex= selectedSoundIndex
        firstLaunch=false
    }
}

