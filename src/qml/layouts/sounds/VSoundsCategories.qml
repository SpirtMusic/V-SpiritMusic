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
    property int columns: 6
    property int rows: 2
    property bool isSelectedCategoryEditable: true

    property var model: sm.getCategories()
    property string selectedCategory: ""
    property string selectedCategoryMainName: ""
    property bool isSelectedCategoryMain: false
    property bool isCurrentSelectedCategoryMain: false
    property int selectedIndex: -1
    property bool isLoading: false  // Add this property to control BusyIndicator visibility
    function refreshModel() {
        if(root.isSelectedCategoryMain){
            model=sm.getSubCategories(root.selectedCategoryMainName)
        }
        else{
            model = sm.getCategories()
            //  isLoading=true
        }
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
        model: root.isLoading ? 0 : root.model
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
                    font.pointSize: 10 *fontScale
                    color:Theme.colorText
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
                        root.selectedIndex = index
                        root.selectedCategory = modelData
                        if(sm.isMainCategory(modelData))
                        {
                            root.isSelectedCategoryMain=true
                            root.selectedCategoryMainName=root.selectedCategory
                            root.model=sm.getSubCategories(root.selectedCategory)
                        }
                        //      console.log("is Main ", sm.isMainCategory(modelData))
                        //  console.log("Clicked category:", modelData)
                    }
                    onPressAndHold: {
                         //if (mouse.source === Qt.MouseEventNotSynthesized)
                        console.log("wwwwwwww")
                        root.selectedIndex = index
                        root.selectedCategory = modelData
                        if(sm.isMainCategory(modelData))
                        {
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
    }
    // Menu {
    //     id: contextMenu
    //     Action { text: "Edit"

    //     onTriggered:{
    //         categoryDialog.mode = "edit"
    //         categoryName.text = root.selectedCategory
    //         categoryDialog.open()
    //     }
    //     icon.source: "qrc:/vsonegx/qml/imgs/cil-pencil.svg"

    //     }
    //     Action { text: "Copy" }
    //     Action { text: "Paste" }
    // }
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
            visible: root.isSelectedCategoryMain
            onClicked: {
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
        VButton {
            text: "Delete Main"
            visible: root.isSelectedCategoryMain && isSelectedCategoryEditable
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
            visible: root.isSelectedCategoryMain && isSelectedCategoryEditable
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
            enabled: root.selectedCategory !== "" && selectedCategory!=selectedCategoryMainName && isSelectedCategoryEditable
            onClicked: exportDialog.open()
            iconSource: "qrc:/vsonegx/qml/imgs/file-export.svg"
            implicitHeightPadding: 10
            Layout.preferredHeight: 30 * heightScale
        }

        VButton {
            text: "Delete"
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
                visible: !root.isSelectedCategoryMain
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
                root.selectedCategoryMainName=currentCategoryMain
                root.model= sm.getSubCategories(currentCategoryMain)
            }
            else{
                root.isSelectedCategoryMain=false
                root.selectedCategoryMainName=""
                root.model= sm.getCategories()
            }
            root.selectedIndex = chCategoryIndex
            root.selectedCategory = chCategory

        }
    }
    Connections {
        target: root
        function onSelectedIndexChanged() {
            gridView.positionViewAtIndex(root.selectedIndex,GridView.Center)

        }
    }

}
