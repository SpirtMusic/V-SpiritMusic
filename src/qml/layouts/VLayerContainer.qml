import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Theme
import "../controls"

Rectangle{
    id:vLayerContainer
    property int baseWidth: rootAppWindow.winBaseWidth
    property int baseHeight: rootAppWindow.winBaseHeight
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight
    property int selectedLayout: 0
    property GridLayout layoutsRowGlobal: layoutsRow
    color:"transparent"
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignVCenter | Qt.AlignVCenter
    Layout.fillHeight: true
    MouseArea {
        anchors.fill: parent
        id: layoutContainer
        preventStealing: true
        property var layers: []
        onPressed: (mouse)=>{
                       console.log("prrrr")
                       for (var i = 0; i < layers.length; ++i) {
                           var currentlayer = layers[i];
                           var layerX = currentlayer.x + layoutsRow.x;
                           var layerY = currentlayer.y + layoutsRow.y;
                           var isToggled
                           isToggled = (mouse.x >= layerX && mouse.x <= layerX + currentlayer.width &&
                                        mouse.y >= layerY && mouse.y <= layerY + currentlayer.height);
                           if (mouse.x >= layerX && mouse.x <= layerX + currentlayer.width &&
                               mouse.y >= layerY && mouse.y <= layerY + currentlayer.height) {
                               currentlayer.layerToggled = true;
                               currentlayer.checked = !currentlayer.checked;
                           }
                           else {
                               currentlayer.layerToggled = false;
                           }
                       }
                       toggleLayers(mouse.x, mouse.y);
                   }
        onPositionChanged:(mouse)=> toggleLayers(mouse.x, mouse.y)

        GridLayout {
            id: layoutsRow
            z:-1
            anchors.fill: parent

            anchors.margins: 20 *heightScale


            VLayerButton {
                id: layer1
                textLayer: "1"
                Component.onCompleted: {
                    layoutContainer.layers.push(layer1);
                }
            }

            VLayerButton {
                id: layer2
                textLayer: "2"
                Component.onCompleted: {
                    layoutContainer.layers.push(layer2);
                }
            }

            VLayerButton {
                id: layer3
                textLayer: "3"
                Component.onCompleted: {
                    layoutContainer.layers.push(layer3);
                }
            }

            VLayerButton {
                id: layer4
                textLayer: "4"
                Component.onCompleted: {
                    layoutContainer.layers.push(layer4);
                }
            }

            VLayerButton {
                id: layer5
                textLayer: "5"
                Component.onCompleted: {
                    layoutContainer.layers.push(layer5);
                }
            }

            VLayerButton {
                id: layer6
                textLayer: "6"
                Component.onCompleted: {
                    layoutContainer.layers.push(layer6);
                }
            }

            VLayerButton {
                id: layer7
                textLayer: "7"
                Component.onCompleted: {
                    layoutContainer.layers.push(layer7);
                }
            }

            VLayerButton {
                id: layer8
                textLayer: "8"
                Component.onCompleted: {
                    layoutContainer.layers.push(layer8);
                }
            }

            VLayerButton {
                id: layer9
                textLayer: "9"
                Component.onCompleted: {
                    layoutContainer.layers.push(layer9);
                }
            }

            VLayerButton {
                id: layer10
                textLayer: "10"
                Component.onCompleted: {
                    layoutContainer.layers.push(layer10);
                }
            }

            VLayerButton {
                id: layer11
                textLayer: "11"
                Component.onCompleted: {
                    layoutContainer.layers.push(layer11);
                }
            }

            VLayerButton {
                id: layer12
                textLayer: "12"
                Component.onCompleted: {
                    layoutContainer.layers.push(layer12);
                }
            }

            VLayerButton {
                id: layer13
                textLayer: "13"
                Component.onCompleted: {
                    layoutContainer.layers.push(layer13);
                }
            }

            VLayerButton {
                id: layer14
                textLayer: "14"
                Component.onCompleted: {
                    layoutContainer.layers.push(layer14);
                }
            }

            VLayerButton {
                id: layer15
                textLayer: "15"
                Component.onCompleted: {
                    layoutContainer.layers.push(layer15);
                }
            }

            VLayerButton {
                id: layer16
                textLayer: "16"
                Component.onCompleted: {
                    layoutContainer.layers.push(layer16);
                }
            }

        }
        function toggleLayers(mouseX, mouseY) {
            for (var i = 0; i < layers.length; ++i) {
                var currentlayer = layers[i];
                var layerX = currentlayer.x + layoutsRow.x;
                var layerY = currentlayer.y + layoutsRow.y;
                if (mouseX >= layerX && mouseX <= layerX + currentlayer.width &&
                        mouseY >= layerY && mouseY <= layerY + currentlayer.height) {
                    if(!currentlayer.layerToggled){
                        currentlayer.checked = !currentlayer.checked;
                        currentlayer.layerToggled = true;
                    }
                    return;
                }

            }
        }
    }
    onHeightChanged:{
        var scale1Default=120*heightScale
        var scale2Default=200*heightScale
        var scale1Layout1=180*heightScale
        var scale2Layout1=350*heightScale
        console.log("selectedLayout :" + vLayerContainer.selectedLayout)
        if(vLayerContainer.selectedLayout==0)
        {
            if(height >= scale1Default && height < scale2Default )
            {
                layoutsRowGlobal.columns=8
                layoutsRowGlobal.rowSpacing=-1
                layoutsRowGlobal.columnSpacing= 20  * heightScale

            }
            else if(height >=scale2Default)
            {

                layoutsRowGlobal.columns=8
                layoutsRowGlobal.rowSpacing=15 * widthScale
                layoutsRowGlobal.columnSpacing= 2 * heightScale

            }
            else{
                layoutsRowGlobal.columns=-1
                layoutsRowGlobal.columnSpacing= -1
                layoutsRowGlobal.rowSpacing= -1

            }
        }
        if(vLayerContainer.selectedLayout==1)
        {
            layoutsRowGlobal.anchors.topMargin= 20
            layoutsRowGlobal.anchors.bottomMargin=20
            if(height >= scale1Layout1 && height < scale2Layout1 )
            {
                layoutsRowGlobal.anchors.topMargin= 30*heightScale
                layoutsRowGlobal.anchors.bottomMargin= 30*heightScale
                layoutsRowGlobal.columns=8
                layoutsRowGlobal.rowSpacing=20  * widthScale
                layoutsRowGlobal.columnSpacing= 1  * heightScale

            }
            else if(height >=scale2Layout1)
            {

                layoutsRowGlobal.columns=8
                layoutsRowGlobal.rowSpacing=10 * widthScale
                layoutsRowGlobal.anchors.topMargin= 125*heightScale
                layoutsRowGlobal.anchors.bottomMargin= 125*heightScale
                layoutsRowGlobal.columnSpacing= -1

            }
            else{

                layoutsRowGlobal.columns=8
                layoutsRowGlobal.rowSpacing=10  * widthScale
                layoutsRowGlobal.columnSpacing= 1  * heightScale
            }
        }

    }
    onWidthChanged:{
        var scale1Default=120*heightScale
        var scale2Default=200*heightScale
        var scale1Layout1=180*heightScale
        var scale2Layout1=350*heightScale
        console.log("selectedLayout :" + vLayerContainer.selectedLayout)
        if(vLayerContainer.selectedLayout==0)
        {
            if(height >= scale1Default && height < scale2Default )
            {
                layoutsRowGlobal.columns=8
                layoutsRowGlobal.rowSpacing=-1
                layoutsRowGlobal.columnSpacing= 20  * heightScale

            }
            else if(height >=scale2Default)
            {

                layoutsRowGlobal.columns=8
                layoutsRowGlobal.rowSpacing=15 * widthScale
                layoutsRowGlobal.columnSpacing= 2 * heightScale

            }
            else{
                layoutsRowGlobal.columns=-1
                layoutsRowGlobal.columnSpacing= -1
                layoutsRowGlobal.rowSpacing= -1

            }
        }
        if(vLayerContainer.selectedLayout==1)
        {
            layoutsRowGlobal.anchors.topMargin= 20
            layoutsRowGlobal.anchors.bottomMargin=20
            if(height >= scale1Layout1 && height < scale2Layout1 )
            {
                layoutsRowGlobal.anchors.topMargin= 30*heightScale
                layoutsRowGlobal.anchors.bottomMargin= 30*heightScale
                layoutsRowGlobal.columns=8
                layoutsRowGlobal.rowSpacing=20  * widthScale
                layoutsRowGlobal.columnSpacing= 1  * heightScale

            }
            else if(height >=scale2Layout1)
            {

                layoutsRowGlobal.columns=8
                layoutsRowGlobal.rowSpacing=10 * widthScale
                layoutsRowGlobal.anchors.topMargin= 125*heightScale
                layoutsRowGlobal.anchors.bottomMargin= 125*heightScale
                layoutsRowGlobal.columnSpacing= -1

            }
            else{

                layoutsRowGlobal.columns=8
                layoutsRowGlobal.rowSpacing=10  * widthScale
                layoutsRowGlobal.columnSpacing= 1  * heightScale
            }
        }

    }
}

