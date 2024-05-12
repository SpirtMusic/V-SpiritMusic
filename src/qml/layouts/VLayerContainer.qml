import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Theme
import "../controls"

Rectangle{
    color:"blue"
    id:myRect
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignVCenter | Qt.AlignVCenter
    height: 120
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
            //Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            columns: 8
            Layout.fillWidth: true
            anchors.leftMargin: 20
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

}

