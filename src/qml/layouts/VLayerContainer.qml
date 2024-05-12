import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

MouseArea {
    id: layoutContainer
    anchors.fill: parent
    preventStealing: true
    z:1
    property var layers: []
    onPressed: (mouse)=>{
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
                           currentlayer.switchToggled = false;
                       }
                   }
                   toggleLayers(mouse.x, mouse.y);
               }
    onPositionChanged:(mouse)=> toggleLayers(mouse.x, mouse.y)

    RowLayout {
        id: layoutsRow
        z:-1
        spacing: 10
        anchors.centerIn: parent

    }
    function toggleLayers(mouseX, mouseY) {
        for (var i = 0; i < layers.length; ++i) {
            var currentlayer = layers[i];
            var layerX = currentlayer.x + layoutsRow.x;
            var layerY = currentlayer.y + layoutsRow.y;
            if (mouseX >= layerX && mouseX <= layerX + currentlayer.width &&
                    mouseY >= layerY && mouseY <= layerY + currentlayer.height) {
                if(!currentlayer.switchToggled){
                    currentlayer.checked = !currentlayer.checked;
                    currentlayer.layerToggled = true;
                }
                return;
            }

        }
    }
}


