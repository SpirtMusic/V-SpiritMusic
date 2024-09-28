import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Theme
import QtQuick.Dialogs
import "../../controls"
Item {
    id: root
    property int baseWidth: rootAppWindow.winBaseWidth
    property int baseHeight: rootAppWindow.winBaseHeight
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight
    property real fontScale: Math.min(widthScale, heightScale)
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignVCenter | Qt.AlignVCenter
    Layout.fillHeight: true
    property int columns: 10
    property int rows: 10
    property bool isEditing: false

    property string currentCategory: rootAppWindow.currentCategory
    property string currentCategoryMain : rootAppWindow.currentCategoryMain
    property var soundModel: []
    property int selectedSoundIndex: -1
    property int selectedIndex: -1
    property int swapselectedSoundIndex: -1
    property int swapselectedIndex: -1
    property bool showEditButtons: false
    property int cellWidth: 150 * widthScale
    property int cellHeight: 40 * heightScale
    property bool setPosition: false
    property string  currentSoundDetailsName: ""
    onSoundModelChanged: {
        gridView.updateGridModel(root.soundModel)
    }
    Connections{
        target:rootAppWindow
        function onCurrentCategoryChanged(){
            setPosition=true
            var chSoundIndex = rootAppWindow.controlIndexSounds.chSoundIndex
            root.currentCategory=rootAppWindow.currentCategory
            root.refreshSoundModel()
            selectedSoundIndex=chSoundIndex
            selectedIndex= chSoundIndex

        }
    }
    Connections {
        target: root
        function onSelectedIndexChanged() {
            if(setPosition)
                gridView.positionViewAtIndex(root.selectedIndex,GridView.Center)
        }
    }
    function refreshSoundModel() {
        if(rootAppWindow.currentCategoryMain==""){
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
    }

    GridView {
        id: gridView
        anchors.top: rowToolBtns.bottom
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        cellWidth: root.cellWidth
        cellHeight: root.cellHeight
        //model: soundModel
        model: ListModel {
            id: combinedModel

            // Function to update the model and append "+ Add new" and "Import..."
            function updateModel(newModel) {
                clear();  // Clear the current proxy model
                // Add the new model items
                for (var i = 0; i < newModel.length; i++) {
                    append({ name: newModel[i] });
                }
                // Append the custom items "+ Add new" and "Import..."
                append({ name: "+ Add new" });
                append({ name: "Import..." });
            }
        }
        function updateGridModel(newModel) {
            combinedModel.updateModel(newModel);
        }
        Component.onCompleted: {
            updateGridModel(root.soundModel)
        }
        anchors.margins: 6
        anchors.topMargin: 2

        // Enable horizontal scrolling
        flow: GridView.FlowTopToBottom
        snapMode: GridView.SnapToRow
        //  orientation: ListView.Horizontal
        flickDeceleration: 1500
        boundsBehavior: Flickable.StopAtBounds

        delegate: Rectangle {
            visible: currentCategory !== ""
            width: root.cellWidth
            height: root.cellHeight
            color:"transparent"
            radius: 4
            border.color:"transparent"
            layer.enabled: true
            layer{
                effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 1
                    verticalOffset: 1
                }
            }
            property var soundDetails: currentCategoryMain!="" ? sm.getSoundSubDetails(currentCategoryMain,currentCategory, modelData): sm.getSoundDetails(currentCategory, modelData)
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
                GradientStop { position: 0.55; color: Theme.colorBackgroundView }
                GradientStop { position: 1.0; color: Theme.colorBackgroundView }
            }
            Rectangle {
                id:glowRec
                anchors.fill: parent
                color:"transparent"
                radius: 4
                border.color:  index === root.selectedIndex  ? Theme.colorSelect :Theme.colorBackgroundView
                z:9999
            }
            Glow {
                anchors.fill: glowRec
                radius: 64
                spread: 0.5
                samples: 128
                color:Theme.colorSelect
                source: glowRec
                visible: index === root.selectedIndex
            }
            Rectangle {
                anchors.fill: parent
                z:-1
                anchors.margins: 2
                border.color:index === root.selectedIndex  ? "transparent" :Theme.colorListBorder
                color:Theme.colorBackgroundView
                border.width: 1
                radius: 4
                Text {
                    anchors.fill: parent
                    text: modelData
                    font.pointSize: 10 *fontScale
                    color:(model.name === "+ Add new") ? "Green" :
                                                         (model.name === "Import...") ? "Green" : Theme.colorText
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: currentCategory !== ""
                    onEntered:{
                        root.setPosition=false
                    }
                    Component.onCompleted: {
                        console.log("CCCCCCCCCCCCC : ",currentCategory)

                    }
                    onClicked: {
                        if (model.name === "+ Add new") {
                            if(rootAppWindow.isCurrentCategoryEditable)
                                soundDialog.openSoundDialog({name: "", msb: 0, lsb: 0, pc: 0})
                            else
                                return
                        } else if (model.name === "Import...") {
                            if(rootAppWindow.isCurrentCategoryEditable)
                                importDialog.open()
                            else
                                return
                        } else {
                            selectedSoundIndex = index
                            root.selectedIndex = index

                            // var soundDetails = sm.getSoundDetails(currentCategory, soundModel[selectedSoundIndex])
                            var soundDetails= currentCategoryMain!=""?sm.getSoundSubDetails(currentCategoryMain,currentCategory, soundModel[selectedSoundIndex]): sm.getSoundDetails(currentCategory, soundModel[selectedSoundIndex])
                            if(soundDetails !== undefined){
                                var pc_value=soundDetails.pc

                                if(rootAppWindow.currentCategoryLevel==1){
                                    pc_value=pc_value-1
                                }

                                mc.sendMsbLsbPc(rootAppWindow.selectedControlIndex,soundDetails.msb,soundDetails.lsb,pc_value)

                                console.log("msb    :", soundDetails.msb)
                                console.log("lsb    :", soundDetails.lsb)
                                console.log("pc     :", soundDetails.pc)
                                console.log("pc_value     :", pc_value)
                                rootAppWindow.controlIndexSounds.chSoundIndex=selectedSoundIndex
                                rootAppWindow.controlIndexSounds.voiceName=soundDetails.name

                            }
                            console.log("Clicked button index:", index)
                        }
                    }
                    onPressAndHold: {
                        if (model.name === "+ Add new") {
                            return
                        } else if (model.name === "Import...") {
                            // Action for "Import..."
                            return
                        }
                        else{
                            swapselectedIndex = root.selectedIndex
                            swapselectedSoundIndex = selectedSoundIndex
                            selectedSoundIndex = index
                            root.selectedIndex = index

                            var soundDetails= currentCategoryMain!=""?sm.getSoundSubDetails(currentCategoryMain,currentCategory, soundModel[selectedSoundIndex]): sm.getSoundDetails(currentCategory, soundModel[selectedSoundIndex])
                            if(soundDetails !== undefined){
                                var pc_value=soundDetails.pc
                                if(rootAppWindow.currentCategoryLevel==1){
                                    pc_value=pc_value-1
                                }
                                root.currentSoundDetailsName=soundDetails.name
                                console.log("msb    :", soundDetails.msb)
                                console.log("lsb    :", soundDetails.lsb)
                                console.log("pc     :", soundDetails.pc)
                                console.log("pc_value     :", pc_value)
                            }
                            contextMenuSounds.popup()
                        }
                    }
                }
            }
        }
    }
    Menu {
        id: contextMenuSounds
        property bool actionTriggered: false
        Action { text: "Edit"
            enabled: selectedSoundIndex !== -1 && rootAppWindow.isCurrentCategoryEditable
            onTriggered: {
                contextMenuSounds.actionTriggered = true
                var soundDetails =currentCategoryMain!=""?sm.getSoundSubDetails(currentCategoryMain,currentCategory, soundModel[selectedSoundIndex]): sm.getSoundDetails(currentCategory, soundModel[selectedSoundIndex])
                soundDialog.openSoundDialog(soundDetails)

            }
            icon.source: "qrc:/vsonegx/qml/imgs/cil-pencil.svg"

        }
        Action { text: "Delete"
            enabled :selectedSoundIndex !== -1  && rootAppWindow.isCurrentCategoryEditable
            onTriggered: {
                contextMenuSounds.actionTriggered = true
                deleteSoundDialog.open()
            }
            icon.source: "qrc:/vsonegx/qml/imgs/cil-trash.svg"
        }
        Action { text: "Import"
            enabled: currentCategory !== ""  && rootAppWindow.isCurrentCategoryEditable
            icon.source:"qrc:/vsonegx/qml/imgs/file-export.svg"
            onTriggered: {
                contextMenuSounds.actionTriggered = true
                importDialog.open()
            }
        }
        Action { text: "Copy"
           // enabled:false
            onTriggered: {
                rootAppWindow.globalSourceCategory=currentCategory
                rootAppWindow.globalSoundName=root.currentSoundDetailsName

            }
        }
        Action { text: "Cut"
            enabled:false
        }
        onAboutToHide: {
            if (!contextMenuSounds.actionTriggered) {
                root.selectedIndex = root.swapselectedIndex;
                root.selectedSoundIndex = root.swapselectedSoundIndex;
            }
            // Reset the flag for the next menu interaction
            contextMenuSounds.actionTriggered = false;
        }
    }

    // Sound Management Buttons
    RowLayout {
        id:rowToolBtns
        anchors.top: parent.top
        //anchors.horizontalCenter: parent.horizontalCenter
        anchors.left:parent.left
        anchors.right: parent.right
        spacing: 10
        anchors.topMargin: 8
        anchors.leftMargin: 4
        anchors.rightMargin: 4
        Item{
            Layout.fillWidth: true
        }

        VButton {
            text: "Add"
            visible: showEditButtons
            enabled: currentCategory !== "" && rootAppWindow.isCurrentCategoryEditable
            onClicked: soundDialog.openSoundDialog({name: "", msb: 0, lsb: 0, pc: 0})
            iconSource: "qrc:/vsonegx/qml/imgs/cil-plus.svg"
            implicitHeightPadding:10
            Layout.preferredHeight: 30 * heightScale
        }
        VButton {
            text: "Edit"
            visible: showEditButtons
            enabled: selectedSoundIndex !== -1 && rootAppWindow.isCurrentCategoryEditable
            onClicked: {
                //  var soundDetails = sm.getSoundDetails(currentCategory, soundModel[selectedSoundIndex])
                var soundDetails =currentCategoryMain!=""?sm.getSoundSubDetails(currentCategoryMain,currentCategory, soundModel[selectedSoundIndex]): sm.getSoundDetails(currentCategory, soundModel[selectedSoundIndex])
                soundDialog.openSoundDialog(soundDetails)
            }
            iconSource: "qrc:/vsonegx/qml/imgs/cil-pencil.svg"
            implicitHeightPadding:10
            Layout.preferredHeight: 30 * heightScale
        }
        VButton {
            text: "Import"
            visible: showEditButtons
            enabled: currentCategory !== ""  && rootAppWindow.isCurrentCategoryEditable
            onClicked: importDialog.open()
            iconSource: "qrc:/vsonegx/qml/imgs/file-export.svg"
            implicitHeightPadding:10
            Layout.preferredHeight: 30 * heightScale
        }
        VButton {
            text: "Delete"
            visible: showEditButtons
            enabled: selectedSoundIndex !== -1  && rootAppWindow.isCurrentCategoryEditable
            onClicked: deleteSoundDialog.open()
            iconSource: "qrc:/vsonegx/qml/imgs/cil-trash.svg"
            implicitHeightPadding:10
            Layout.preferredHeight: 30 * heightScale
        }

    }

    Dialog {
        id: importDialog
        title: "Import Sounds"
        standardButtons: Dialog.Ok | Dialog.Cancel
        parent: rootAppWindow
        anchors.centerIn: parent
        modal: true
        width: 400 * widthScale
        height: 300 * heightScale
        property string resultMessage: ""
        background: Rectangle {
            color: Theme.colorBackgroundView
        }

        contentItem: ColumnLayout {
            spacing: 10
            TextArea {
                id: importTextArea
                Layout.fillWidth: true
                Layout.fillHeight: true
                placeholderText: "Paste your sound data here..."
                wrapMode: TextArea.Wrap
            }
            VButton {
                text: "Select File"
                onClicked: fileDialog.open()
            }
        }

        onAccepted: {
            if (importTextArea.text.trim() !== "") {
                var success
                if(currentCategoryMain==""){
                    success = sm.importSounds(currentCategory, importTextArea.text.trim())
                }
                else
                {
                    success = sm.importSubSounds(currentCategoryMain,currentCategory, importTextArea.text.trim())
                }

                if (success) {
                    importDialog.resultMessage = "Sounds imported successfully"
                    console.log("Sounds imported successfully")
                    refreshSoundModel()
                    msgDlg.text="Sounds imported successfully !"
                    msgDlg.open()
                } else {
                    importDialog.resultMessage = "Error importing sounds. Check console for details."
                    console.error("Error importing sounds")
                    msgDlg.text="Error importing sounds !"
                    msgDlg.open()
                }
            }
        }
        function clearAndReset() {
            importTextArea.text = ""
            resultMessage = ""
        }

        // Call clearAndReset when the dialog is opened
        onAboutToShow: {
            clearAndReset()
        }

        // Also call clearAndReset when the dialog is closed
        onClosed: {
            clearAndReset()
        }
    }
    FileDialog {
        id: fileDialog
        title: "Select sound data file"
        nameFilters: ["Text files (*.txt)"]
        onAccepted: {
            var request = new XMLHttpRequest();
            request.open("GET", fileDialog.selectedFile, false);
            request.send(null);
            if (request.status === 200) {
                importTextArea.text = request.responseText;

            } else {
                console.error("Failed to load file");

            }
        }
    }
    MessageDialog {
        id:msgDlg
        buttons: MessageDialog.Ok
        text: "The document has been modified."
    }
    // Sound Add/Edit Dialog
    Dialog {
        id: soundDialog
        title: "Add/Edit Sound"
        standardButtons: Dialog.Ok | Dialog.Cancel

        property string originalName: ""
        parent: rootAppWindow
        anchors.centerIn: parent
        modal: true
        width: 200*widthScale
        height: 200 *heightScale
        background: Rectangle {
            color:  Theme.colorBackgroundView
        }
        function openSoundDialog(soundDetails) {
            if (!soundDetails || soundDetails.name === undefined) {
                console.error("Invalid sound details provided:", soundDetails);
                return;
            }
            isEditing = soundDetails !== undefined;
            console.log("  sound details provided:", soundDetails);
            if (isEditing) {
                soundDialog.originalName = soundDetails.name || "";
                soundNameField.text = soundDetails.name || "";
                soundMSB.value = soundDetails.msb || 0;
                soundLSB.value = soundDetails.lsb || 0;
                soundPC.value = soundDetails.pc || 0;
            } else {
                soundDialog.originalName = ""
                soundNameField.text = ""
                soundMSB.value = 0
                soundLSB.value = 0
                soundPC.value = 0
            }

            soundDialog.open()
        }

        GridLayout {
            columns: 2
            anchors.fill: parent
            Label { text: "Name:" }
            TextField { id: soundNameField
                Layout.fillWidth: true
            }

            Label { text: "MSB:" }
            SpinBox { id: soundMSB; from: 0; to: 127
                Layout.fillWidth: true
                editable: true

            }

            Label { text: "LSB:" }
            SpinBox { id: soundLSB; from: 0; to: 127
                Layout.fillWidth: true
                editable: true

            }

            Label { text: "PC:" }
            SpinBox { id: soundPC; from: 0; to: 127
                Layout.fillWidth: true
                editable: true

            }
        }

        onAccepted: {

            if(currentCategoryMain==""){
                sm.saveSound(currentCategory, soundNameField.text, soundMSB.value, soundLSB.value, soundPC.value)

                if (originalName !== "" && originalName !== soundNameField.text) {
                    sm.deleteSound(currentCategory, originalName)
                }
            }
            else {
                sm.saveSubSound(currentCategoryMain,currentCategory, soundNameField.text, soundMSB.value, soundLSB.value, soundPC.value)

                if (originalName !== "" && originalName !== soundNameField.text) {
                    sm.deleteSubSound(currentCategoryMain,currentCategory, originalName)
                }
            }

            refreshSoundModel()
            root.restoreItemSelection()
        }
    }

    // Sound Delete Confirmation Dialog
    Dialog {
        id: deleteSoundDialog
        title: "Delete Sound"
        standardButtons: Dialog.Yes | Dialog.No
        parent: rootAppWindow
        anchors.centerIn: parent
        modal: true
        width: 300*widthScale
        height: 150 *heightScale

        background: Rectangle {
            color:  Theme.colorBackgroundView
        }

        contentItem: ColumnLayout {
            spacing: 10
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font.pointSize: 10* fontScale
                color:Theme.colorText
                text: "Are you sure you want to delete the sound '" + (soundModel[selectedSoundIndex] || "") + "'?"
            }
        }

        onAccepted: {
            if(currentCategoryMain==""){
                sm.deleteSound(currentCategory, soundModel[selectedSoundIndex])

            }
            else{
                sm.deleteSubSound(currentCategoryMain,currentCategory, soundModel[selectedSoundIndex])

            }
            refreshSoundModel()
            selectedSoundIndex = -1
            root.restoreItemSelection()

        }
    }

    function restoreItemSelection(){
        let lastIndex = gridView.count - 1;  // Last index corresponds to "+ Add new"
        let secondToLastIndex = lastIndex - 1;  // Second-to-last index corresponds to "Import..."
        let itemBeforeSpecial = lastIndex - 2;  // Item before "+ Add new" and "Import..."

        // Check if the current selected item is one of the special items
        let selectedAtSpecial = root.selectedIndex === lastIndex || root.selectedIndex === secondToLastIndex;

        // Check if swapselectedIndex is within the valid range
        let swapIndexValid = root.swapselectedIndex >= 0 && root.swapselectedIndex < itemBeforeSpecial + 1;

        // If deleting a special item or the item before "+ Add new", use fallback
        if (selectedAtSpecial || root.selectedIndex === itemBeforeSpecial) {
            if (swapIndexValid) {
                // Restore swapselectedIndex if valid
                root.selectedIndex = root.swapselectedIndex;
                root.selectedSoundIndex = root.swapselectedSoundIndex;
            } else if (itemBeforeSpecial >= 0) {
                // Fallback to selecting the item before the special items
                root.selectedIndex = itemBeforeSpecial;
            } else {
                // If no valid items, set selectedIndex to -1
                root.selectedIndex = -1;
            }
        } else if (root.selectedIndex === itemBeforeSpecial + 1 && swapIndexValid) {
            // If deleting the last valid item before the special items and swapselectedIndex is valid
            root.selectedIndex = root.swapselectedIndex;
            root.selectedSoundIndex = root.swapselectedSoundIndex;
        } else if (swapIndexValid) {
            // Otherwise, restore swapselectedIndex if it's valid
            root.selectedIndex = root.swapselectedIndex;
            root.selectedSoundIndex = root.swapselectedSoundIndex;
        } else {
            // If all else fails, fallback to the last valid item
            if (itemBeforeSpecial >= 0) {
                root.selectedIndex = itemBeforeSpecial;
            } else {
                root.selectedIndex = -1;
            }
        }
    }
}
