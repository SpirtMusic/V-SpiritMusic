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
    property var soundModel: []
    property int selectedSoundIndex: -1


    property int selectedIndex: -1
    property int cellWidth: 150 * widthScale
    property int cellHeight: 40 * heightScale
    Connections{
        target:rootAppWindow
        function onCurrentCategoryChanged(){
            root.currentCategory=rootAppWindow.currentCategory
            root.refreshSoundModel()
            selectedSoundIndex=-1
            selectedIndex= -1
        }

    }
    function refreshSoundModel() {
        if (currentCategory !== "") {
            soundModel = sm.getSoundsForCategory(currentCategory)
        } else {
            soundModel = []
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
        model: soundModel
        anchors.margins: 6
        anchors.topMargin: 2

        // Enable horizontal scrolling
        flow: GridView.FlowTopToBottom
        snapMode: GridView.SnapToRow
        //  orientation: ListView.Horizontal
        flickDeceleration: 1500
        boundsBehavior: Flickable.StopAtBounds

        delegate: Rectangle {
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
            property var soundDetails: sm.getSoundDetails(currentCategory, modelData)
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
                    color:Theme.colorText
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        selectedSoundIndex = index
                        root.selectedIndex = index

                        var soundDetails = sm.getSoundDetails(currentCategory, soundModel[selectedSoundIndex])
                        if(soundDetails !== undefined){
                            mc.sendMsbLsbPc(rootAppWindow.selectedControlIndex,soundDetails.msb,soundDetails.lsb,soundDetails.pc)
                            rootAppWindow.controlIndexSounds.voiceName=soundDetails.name

                        }
                        console.log("Clicked button index:", index)
                    }
                }
            }
        }
    }

    // Sound Management Buttons
    RowLayout {
        id:rowToolBtns
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10
        anchors.topMargin: 8


        VButton {
            text: "Add"
            enabled: currentCategory !== ""
            onClicked: soundDialog.openSoundDialog({name: "", msb: 0, lsb: 0, pc: 0})
            iconSource: "qrc:/vsonegx/qml/imgs/cil-plus.svg"
            implicitHeightPadding:10
            Layout.preferredHeight: 30 * heightScale
        }
        VButton {
            text: "Edit"
            enabled: selectedSoundIndex !== -1
            onClicked: {
                var soundDetails = sm.getSoundDetails(currentCategory, soundModel[selectedSoundIndex])
                soundDialog.openSoundDialog(soundDetails)
            }
            iconSource: "qrc:/vsonegx/qml/imgs/cil-pencil.svg"
            implicitHeightPadding:10
            Layout.preferredHeight: 30 * heightScale
        }
        VButton {
            text: "Import"
            enabled: currentCategory !== ""
            onClicked: importDialog.open()
            iconSource: "qrc:/vsonegx/qml/imgs/file-export.svg"
            implicitHeightPadding:10
            Layout.preferredHeight: 30 * heightScale
        }
        VButton {
            text: "Delete"
            enabled: selectedSoundIndex !== -1
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
                var success = sm.importSounds(currentCategory, importTextArea.text.trim())
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
            sm.saveSound(currentCategory, soundNameField.text, soundMSB.value, soundLSB.value, soundPC.value)

            if (originalName !== "" && originalName !== soundNameField.text) {
                sm.deleteSound(currentCategory, originalName)
            }

            refreshSoundModel()
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
            sm.deleteSound(currentCategory, soundModel[selectedSoundIndex])
            refreshSoundModel()
            selectedSoundIndex = -1
        }
    }


}
