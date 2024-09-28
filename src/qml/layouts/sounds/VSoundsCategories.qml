import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Theme
import QtQuick.Dialogs
import "../../controls"
// TODO : Hide + add item on genos list
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
    property int columns: 6
    property int rows: 2
    property bool isSelectedCategoryEditable: true

    property var model: sm.getCategories()
    property string selectedCategory: ""
    property string selectedCategoryMainName: ""
    property bool isSelectedCategoryMain: false
    property bool isCurrentSelectedCategoryMain: false
    property bool showEditButtons: false
    property bool isInsideMainCategory: false
    property int selectedIndex: -1

    property int swapselectedIndex: -1
    property string swapselectedCategory: ""
    property bool swapisSelectedCategoryMain:false
    property string swapselectedCategoryMainName: ""
    property bool isLoading: false  // Add this property to control BusyIndicator visibility

    property bool copyMode: false

    function refreshModel() {
        if(root.isSelectedCategoryMain){
            root.isInsideMainCategory=true
            model=sm.getSubCategories(root.selectedCategoryMainName)
        }
        else{
            model = sm.getCategories()
            //  isLoading=true
        }
    }
    onModelChanged: {
        gridView.updateGridModel(root.model)
    }
    onSelectedCategoryMainNameChanged:{
        rootAppWindow.currentCategoryMain=selectedCategoryMainName
    }
    onSelectedCategoryChanged: {
        rootAppWindow.currentCategory=selectedCategory
        rootAppWindow.controlIndexSounds.chCatgeoryIndex = selectedIndex
        rootAppWindow.controlIndexSounds.chCategory = selectedCategory
        console.log(" root.selectedIndex " ,  root.selectedIndex)
        if(root.isSelectedCategoryMain){

            var main_level=sm.getCategoryLevel(selectedCategoryMainName)
            rootAppWindow.controlIndexSounds.chIsInMain=true
            rootAppWindow.controlIndexSounds.chMainCategory =selectedCategoryMainName
            if(main_level===1||main_level===2){
                rootAppWindow.currentCategoryLevel=main_level
                isSelectedCategoryEditable=false
                rootAppWindow.isCurrentCategoryEditable=false
            }
            else{
                isSelectedCategoryEditable=true
                rootAppWindow.currentCategoryLevel=0
                rootAppWindow.isCurrentCategoryEditable=true
            }
        }
        else{
            rootAppWindow.controlIndexSounds.chIsInMain=false
            rootAppWindow.controlIndexSounds.chMainCategory = ""
            var level=sm.getCategoryLevel(selectedCategory)
            if(level===1||level===2){
                isSelectedCategoryEditable=false
                rootAppWindow.currentCategoryLevel=level
                rootAppWindow.isCurrentCategoryEditable=false
            }
            else{
                isSelectedCategoryEditable=true
                rootAppWindow.currentCategoryLevel=0
                rootAppWindow.isCurrentCategoryEditable=true
            }
        }
        console.log("  root.categoryLevel : ",  root.categoryLevel)
    }
    property int cellWidth: 120 * widthScale
    property int cellHeight: 47 * heightScale

    GridView {
        id: gridView
        anchors.top: rowToolBtns.bottom
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        cellWidth: root.cellWidth
        cellHeight: root.cellHeight
        // model: root.isLoading ? 0 : root.model
        anchors.margins: 6
        anchors.topMargin: 2
        model: ListModel {
            id: combinedModel

            // Function to update the model and append "+ Add new"
            function updateModel(newModel) {
                clear();  // Clear the current proxy model
                // Add the new model items
                for (var i = 0; i < newModel.length; i++) {
                    append({ name: newModel[i] });
                }
                // Append the custom item "+ Add new"
                append({ name: "+ Add new" });
            }
        }
        function updateGridModel(newModel) {
            combinedModel.updateModel(newModel);
        }
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
                border.color: index === root.selectedIndex  ? "transparent" :Theme.colorListBorder
                color:Theme.colorBackground
                border.width: 1
                radius: 4
                Text {
                    id:categoryLabel
                    // anchors.fill: parent
                    anchors.top:parent.top
                    anchors.bottom: parent.bottom
                    anchors.right : categoryLevel.visible || categoryMain.visible?  categoryLevel.left : parent.right
                    anchors.left : parent.left
                    anchors.leftMargin: 4
                    text: modelData
                    font.pointSize: (model.name === "+ Add new") ? 12 *fontScale: 10 *fontScale
                    color:(model.name === "+ Add new") ? "Green" : Theme.colorText
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Item {
                            width: categoryLevel.width
                            height: categoryLevel.height

                            LinearGradient {
                                anchors.fill: parent
                                start: Qt.point(width/1.5, 0)
                                end: Qt.point(width, 0)
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: "white" }
                                    GradientStop { position: 1.0; color: "transparent" }
                                }
                            }
                        }
                    }
                }
                Image {
                    id:categoryMain
                    anchors.right : parent.right
                    anchors.rightMargin: 4
                    anchors.top:parent.top
                    anchors.topMargin: 2
                    anchors.bottomMargin: 1
                    height:  parent.height/2.5
                    width: height
                    opacity: 0.7
                    source:"qrc:/vsonegx/qml/imgs/cil-list.svg"
                    // anchors.margins: 2
                    sourceSize.height: height
                    sourceSize.width: height
                    visible: false
                    //  antialiasing: true
                    Component.onCompleted: {
                        checkCategoryIsMain()
                    }
                    ColorOverlay {
                        color: Theme.colorText
                        anchors.fill: parent
                        source: parent
                        //  antialiasing: true
                        // cached: true
                    }
                    function checkCategoryIsMain(){
                        var isMain = sm.isMainCategory(modelData)
                        if(isMain){
                            visible=true
                        }
                        else{
                            visible=false
                        }
                    }
                }
                Image {
                    id:categoryLevel
                    anchors.right : parent.right
                    anchors.rightMargin: 4
                    anchors.top:categoryMain.bottom
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 1 // parent.height/2.5
                    anchors.bottomMargin:  2
                    height:  parent.height/2
                    width: height
                    opacity: 0.7
                    // anchors.margins: 2
                    sourceSize.height: height
                    sourceSize.width: height
                    //  antialiasing: true
                    Component.onCompleted: {
                        checkCategoryLevel()
                    }
                    ColorOverlay {
                        color: Theme.colorText
                        anchors.fill: parent
                        source: parent
                        //  antialiasing: true
                        // cached: true
                    }
                    function checkCategoryLevel(){
                        if(!root.isSelectedCategoryMain){
                            var level = sm.getCategoryLevel(modelData)

                            switch(level){
                            case 0:
                                categoryLevel.visible=false
                                break
                            case 1:
                                categoryLevel.source="qrc:/vsonegx/qml/imgs/yamaha.svg"
                                break
                            case 2:
                                categoryLevel.source="qrc:/vsonegx/qml/imgs/VSpiritMusic.png"
                                break
                            default:
                                categoryLevel.visible=false
                            }
                        }
                        else{
                            categoryLevel.visible=false
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (model.name === "+ Add new") {
                            // If the custom item is clicked, open the dialog
                            categoryDialog.mode = "add"
                            categoryDialog.open()
                        }
                        else{
                            root.selectedIndex = index
                            root.selectedCategory = modelData
                            if(sm.isMainCategory(modelData))
                            {
                                root.isSelectedCategoryMain=true
                                root.selectedCategoryMainName=root.selectedCategory
                                root.model=sm.getSubCategories(root.selectedCategory)
                                root.isInsideMainCategory=true

                            }
                        }
                        //      console.log("is Main ", sm.isMainCategory(modelData))
                        //  console.log("Clicked category:", modelData)
                    }
                    onPressAndHold: {
                        root.swapselectedIndex=root.selectedIndex
                        root.swapselectedCategory=root.selectedCategory
                        if (model.name === "+ Add new") {
                            // If the custom item is clicked, open the dialog
                            return
                        }
                        //if (mouse.source === Qt.MouseEventNotSynthesized)
                        console.log("wwwwwwww")
                        root.selectedIndex = index
                        root.selectedCategory = modelData
                        if(sm.isMainCategory(modelData))
                        {
                            root.swapisSelectedCategoryMain=  root.isSelectedCategoryMain
                            root.swapselectedCategoryMainName = root.selectedCategoryMainName
                            root.isSelectedCategoryMain=true
                            root.selectedCategoryMainName=root.selectedCategory

                        }
                        contextMenu.popup()
                    }
                }
            }
        }
        BusyIndicator {
            anchors.centerIn: parent
            running: root.isLoading
            visible: root.isLoading
        }
        Component.onCompleted: {
            updateGridModel(root.model)
        }
    }
    Menu {
        id: contextMenu
        property bool actionTriggered: false
        Action { text: "Edit"
            enabled: isSelectedCategoryEditable

            onTriggered:{
                contextMenu.actionTriggered = true
                if(root.isSelectedCategoryMain && root.selectedCategoryMainName==root.selectedCategory){
                    categoryDialog.mode = "rename"
                    categoryName.text = root.selectedCategoryMainName
                }
                else {
                    categoryDialog.mode = "edit"
                    categoryName.text = root.selectedCategory
                }
                categoryDialog.open()
            }
            icon.source: "qrc:/vsonegx/qml/imgs/cil-pencil.svg"

        }
        Action { text: "Delete"
            enabled: isSelectedCategoryEditable
            onTriggered:{
                contextMenu.actionTriggered = true
                if(root.isSelectedCategoryMain && root.selectedCategoryMainName==root.selectedCategory){
                    root.isCurrentSelectedCategoryMain=true
                    deleteCategoryDialog.open()
                }
                else {
                    deleteCategoryDialog.open()
                }
            }
            icon.source: "qrc:/vsonegx/qml/imgs/cil-trash.svg"
        }
        Action { text: "Export"
            enabled: isSelectedCategoryEditable && !root.isSelectedCategoryMain
            onTriggered:{
                contextMenu.actionTriggered = true
                exportDialog.open()
            }
            icon.source: "qrc:/vsonegx/qml/imgs/file-export.svg"
        }
        Action { text: "Paste"
            enabled: root.copyMode
            onTriggered: {
                var sourceCategory=rootAppWindow.globalSourceCategory
                var soundNameToCopy = rootAppWindow.globalSoundName
                let result = sm.copySoundBetweenCategories(
                        sourceCategory,
                        root.selectedCategory,
                        soundNameToCopy
                        )
                switch(result.status) {
                case 0:
                    if (result.newName !== soundNameToCopy) {
                        console.log("Sound copied successfully and renamed to: " + result.newName)
                    } else {
                        console.log("Sound copied successfully")
                    }
                    // Refresh your sound list view
                    break
                case 1:
                    console.log("Sound not found in source category")
                    break
                }
                root.copyMode=false
                rootAppWindow.globalSoundName=""
            }
        }
        onAboutToHide: {
            onAboutToHide: {
                if (!contextMenu.actionTriggered) {
                    if(!root.isInsideMainCategory){
                        root.selectedIndex=  root.swapselectedIndex
                        root.selectedCategory=  root.swapselectedCategory
                        root.isSelectedCategoryMain = root.swapisSelectedCategoryMain
                        root.selectedCategoryMainName =  root.swapselectedCategoryMainName
                    }
                }
                // Reset the flag for the next menu interaction
                contextMenu.actionTriggered = false;
            }
        }
    }
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
        VButton {
            text: "Back"
            visible: (root.isSelectedCategoryMain && isInsideMainCategory) || isInsideMainCategory
            onClicked: {
                root.isInsideMainCategory=false
                root.isSelectedCategoryMain=false
                root.selectedCategory=""
                root.selectedCategoryMainName=""
                root.isSelectedCategoryEditable=true
                root.refreshModel()
            }
            iconSource: "qrc:/vsonegx/qml/imgs/cil-arrow-left.svg"
            implicitHeightPadding:10
            Layout.preferredHeight: 30 * heightScale
        }
        Text {
            id: name
            text: root.isSelectedCategoryMain ? selectedCategoryMainName : qsTr("Categories")
            color:Theme.colorText
            Layout.leftMargin: 5
            font.pointSize: 14 *fontScale

        }
        Text {
            id: soundName
            visible: root.copyMode
            text: " Copy : " + rootAppWindow.globalSoundName
            color:Theme.colorText
            Layout.leftMargin: 5
            font.pointSize: 14 *fontScale

        }
        VButton {
            text: "Delete Main"
            visible: root.isSelectedCategoryMain && isSelectedCategoryEditable && showEditButtons
            onClicked: {
                root.isCurrentSelectedCategoryMain=true
                deleteCategoryDialog.open()
            }
            iconSource: "qrc:/vsonegx/qml/imgs/cil-trash.svg"
            implicitHeightPadding:10
            Layout.preferredHeight: 30 * heightScale
        }
        VButton {
            text: "Edit Main"
            visible: root.isSelectedCategoryMain && isSelectedCategoryEditable && showEditButtons
            onClicked: {
                categoryDialog.mode = "rename"
                categoryName.text = root.selectedCategoryMainName
                categoryDialog.open()
            }
            iconSource: "qrc:/vsonegx/qml/imgs/cil-pencil.svg"
            implicitHeightPadding:10
            Layout.preferredHeight: 30 * heightScale
        }
        Item {
            Layout.fillWidth: true
        }
        VButton {
            text: "Add"
            visible: showEditButtons
            onClicked: {
                categoryDialog.mode = "add"
                categoryDialog.open()
            }
            enabled:  isSelectedCategoryEditable &&  root.isSelectedCategoryMain || !root.isSelectedCategoryMain
            iconSource: "qrc:/vsonegx/qml/imgs/cil-plus.svg"
            implicitHeightPadding:10
            Layout.preferredHeight: 30 * heightScale
        }

        VButton {
            text: "Edit"
            visible: showEditButtons
            enabled: root.selectedCategory !== "" && isSelectedCategoryEditable &&  selectedCategory!=selectedCategoryMainName
            onClicked: {
                categoryDialog.mode = "edit"
                categoryName.text = root.selectedCategory
                categoryDialog.open()
            }
            iconSource: "qrc:/vsonegx/qml/imgs/cil-pencil.svg"
            implicitHeightPadding:10
            Layout.preferredHeight: 30 * heightScale
        }
        VButton {
            text: "Export"
            visible: showEditButtons
            enabled: root.selectedCategory !== "" && selectedCategory!=selectedCategoryMainName && isSelectedCategoryEditable
            onClicked: exportDialog.open()
            iconSource: "qrc:/vsonegx/qml/imgs/file-export.svg"
            implicitHeightPadding: 10
            Layout.preferredHeight: 30 * heightScale
        }

        VButton {
            text: "Delete"
            visible: showEditButtons
            enabled: root.selectedCategory !== "" && selectedCategory!=selectedCategoryMainName && isSelectedCategoryEditable
            onClicked: {
                deleteCategoryDialog.open()
            }
            iconSource: "qrc:/vsonegx/qml/imgs/cil-trash.svg"
            implicitHeightPadding:10
            Layout.preferredHeight: 30 * heightScale
        }
    }
    Dialog {
        id: exportDialog
        title: "Export Sounds"
        standardButtons: Dialog.Ok | Dialog.Cancel
        parent: rootAppWindow
        anchors.centerIn: parent
        modal: true
        width: 400 * widthScale
        height: 300 * heightScale
        background: Rectangle {
            color: Theme.colorBackgroundView
        }

        property string exportedContent: ""

        contentItem: ColumnLayout {
            spacing: 10
            TextArea {
                id: exportTextArea
                Layout.fillWidth: true
                Layout.fillHeight: true
                readOnly: true
                wrapMode: TextArea.Wrap
                text: exportDialog.exportedContent
            }
            RowLayout {
                Layout.alignment: Qt.AlignRight
                VButton {
                    text: "Copy to Clipboard"
                    onClicked: {
                        exportTextArea.selectAll()
                        exportTextArea.copy()
                        exportTextArea.deselect()
                    }
                }
                VButton {
                    text: "Save to File"
                    onClicked: saveFileDialog.open()
                }
            }
        }

        onAboutToShow: {
            console.log("root.selectedCategoryMainName",root.selectedCategoryMainName)
            if(root.isSelectedCategoryMain)
                exportedContent=sm.exportSubSounds(root.selectedCategoryMainName,currentCategory)
            else
                exportedContent = sm.exportSounds(currentCategory)
        }
    }
    MessageDialog {
        id:msgDlg
        buttons: MessageDialog.Ok
        text: "The document has been modified."
    }
    FileDialog {
        id: saveFileDialog
        title: "Save exported sounds"
        nameFilters: ["Text files (*.txt)"]
        fileMode: FileDialog.SaveFile
        onAccepted: {
            if (sm.saveSoundsToFile(saveFileDialog.selectedFile, exportDialog.exportedContent)) {
                console.log("File saved successfully");
                msgDlg.text="Category exported successfully!"
                msgDlg.open()
            } else {
                console.error("Failed to save file");
                msgDlg.text="Failed to export Category!"
                msgDlg.open()
            }
        }
    }

    Dialog {
        id: categoryDialog
        property string mode: "add"
        property string oldCategoryName: ""
        title: {
            switch(mode) {
            case "add": return "Add Category"
            case "edit": return "Edit Category"
            case "rename": return "Rename Main Category"
            default: return "Category Dialog"
            }
        }
        standardButtons: Dialog.Ok | Dialog.Cancel
        parent: rootAppWindow
        anchors.centerIn: parent
        modal: true
        width: 300 * widthScale
        height: 150 * heightScale
        background: Rectangle {
            color: Theme.colorBackgroundView
        }
        contentItem: ColumnLayout {
            spacing: 10
            VCheckBox {
                id: isMainCategoryCheckBox
                text: "Main Category"
                checked: false
                visible: categoryDialog.mode=="add"
            }
            TextField {
                id: categoryName
                Layout.fillWidth: true
                placeholderText: "Enter category name"
                text: categoryDialog.mode === "add" ? "" : root.selectedCategory
            }
        }
        onOpened: {
            if (mode === "add") {
                categoryName.text = ""
                oldCategoryName = ""
            }
            else if (mode === "rename") {
                oldCategoryName = root.selectedCategoryMainName
                categoryName.text = oldCategoryName
            }
            else {
                oldCategoryName = root.selectedCategory
                categoryName.text = oldCategoryName
            }
        }
        onAccepted: {
            if (mode === "rename") {
                let result = sm.renameMainCategory(oldCategoryName, categoryName.text)
                switch(result) {
                case 0:
                    console.log("Main category renamed successfully")
                    root.refreshModel()
                    root.isSelectedCategoryMain=true
                    root.selectedCategoryMainName=categoryName.text
                    break
                case 1:
                    console.log("New category name already exists")
                    break
                case 2:
                    console.log("Old category not found")
                    break
                }
            } else if (root.isSelectedCategoryMain) {
                let result = sm.saveSubCategory(root.selectedCategoryMainName, categoryName.text, mode === "add" ? 0 : 1, oldCategoryName)
                handleSaveResult(result)
            } else {
                let result = sm.saveCategory(categoryName.text, mode === "add" ? 0 : 1, oldCategoryName, isMainCategoryCheckBox.checked, 0)
                handleSaveResult(result)
            }
        }

        function handleSaveResult(result) {
            switch(result) {
            case 0:
                console.log("Category saved successfully")
                root.refreshModel()
                if (mode === "edit") {
                    root.selectedCategory = categoryName.text
                }
                break
            case 1:
                console.log("Category already exists")
                break
            case 2:
                console.log("New category name already exists")
                break
            case 3:
                console.log("Old category not found")
                break
            case 4:
                console.log("Invalid mode")
                break
            }
        }
    }
    Dialog {
        id: deleteCategoryDialog
        title: "Delete Category"
        standardButtons: Dialog.Yes | Dialog.No
        parent: rootAppWindow
        anchors.centerIn: parent
        modal: true
        width: 300 *widthScale
        height: 150 *heightScale
        background: Rectangle {
            color:  Theme.colorBackgroundView
        }
        contentItem: ColumnLayout {
            spacing: 10
            Text {
                property string  nameCategory:  root.isCurrentSelectedCategoryMain ? root.selectedCategoryMainName +", This will also delete all sub-categories " : root.selectedCategory
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font.pointSize: 10* fontScale
                color:Theme.colorText
                text: "Are you sure you want to delete the category '" +  nameCategory + "'?"
            }
        }

        onAccepted: {
            if(root.isCurrentSelectedCategoryMain){
                sm.deleteMainCategory(root.selectedCategoryMainName)
                root.isCurrentSelectedCategoryMain=false
                root.isSelectedCategoryMain=false
                root.selectedCategoryMainName=""
                root.refreshModel()

            }
            else if(root.isSelectedCategoryMain){
                sm.deleteSubCategory(root.selectedCategoryMainName,root.selectedCategory)
            }
            else {
                sm.deleteCategory(root.selectedCategory)
            }
            root.refreshModel()
            root.selectedCategory = ""
            root.selectedIndex = -1
        }
    }
    Connections {
        target: sm
        function onCategoriesLoaded() {
            root.refreshModel()
            root.isLoading = false
        }
    }
    Connections {
        target: rootAppWindow
        function onControlIndexSoundsChanged() {
            var chCategoryIndex = rootAppWindow.controlIndexSounds.chCatgeoryIndex
            var isMainCategory =  rootAppWindow.controlIndexSounds.chIsInMain
            var chCategory =  rootAppWindow.controlIndexSounds.chCategory
            var currentCategoryMain =  rootAppWindow.controlIndexSounds.chMainCategory
            if(isMainCategory){
                root.isSelectedCategoryMain=true
                root.isInsideMainCategory=true
                root.selectedCategoryMainName=currentCategoryMain
                root.model= sm.getSubCategories(currentCategoryMain)
            }
            else{
                root.isInsideMainCategory=false
                root.isSelectedCategoryMain=false
                root.selectedCategoryMainName=""
                root.model= sm.getCategories()
            }
            root.selectedIndex = chCategoryIndex
            root.selectedCategory = chCategory

        }
        function onGlobalSoundNameChanged(){
            if(rootAppWindow.globalSoundName!=""){
                console.log("rootAppWindow.globalSoundName  ",rootAppWindow.globalSoundName)
                root.copyMode=true
            }
            else
                root.copyMode=false
        }
    }
    Connections {
        target: root
        function onSelectedIndexChanged() {
            gridView.positionViewAtIndex(root.selectedIndex,GridView.Center)

        }
    }
    // function restoreItemSelection(){
    //     let lastIndex = gridView.count - 1;  // Last index corresponds to "+ Add new"
    //      let itemBeforeSpecial = lastIndex - 1;  // Item before "+ Add new"

    //      // Check if the current selected item is "+ Add new"
    //      let selectedAtSpecial = root.selectedIndex === lastIndex;

    //      // Check if swapselectedIndex is within the valid range
    //      let swapIndexValid = root.swapselectedIndex >= 0 && root.swapselectedIndex < itemBeforeSpecial + 1;

    //      // If deleting "+ Add new" or the item before "+ Add new", use fallback
    //      if (selectedAtSpecial || root.selectedIndex === itemBeforeSpecial) {
    //          if (swapIndexValid) {
    //              // Restore swapselectedIndex if valid
    //              root.selectedIndex = root.swapselectedIndex;
    //              root.selectedSoundIndex = root.swapselectedSoundIndex;
    //          } else if (itemBeforeSpecial >= 0) {
    //              // Fallback to selecting the item before "+ Add new"
    //              root.selectedIndex = itemBeforeSpecial;
    //          } else {
    //              // If no valid items, set selectedIndex to -1
    //              root.selectedIndex = -1;
    //          }
    //      } else if (root.selectedIndex === itemBeforeSpecial + 1 && swapIndexValid) {
    //          // If deleting the last valid item before "+ Add new" and swapselectedIndex is valid
    //          root.selectedIndex = root.swapselectedIndex;
    //          root.selectedSoundIndex = root.swapselectedSoundIndex;
    //      } else if (swapIndexValid) {
    //          // Otherwise, restore swapselectedIndex if it's valid
    //          root.selectedIndex = root.swapselectedIndex;
    //          root.selectedSoundIndex = root.swapselectedSoundIndex;
    //      } else {
    //          // If all else fails, fallback to the last valid item
    //          if (itemBeforeSpecial >= 0) {
    //              root.selectedIndex = itemBeforeSpecial;
    //          } else {
    //              root.selectedIndex = -1;
    //          }
    //      }

    // }
}
