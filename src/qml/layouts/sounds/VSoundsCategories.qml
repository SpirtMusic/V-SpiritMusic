import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Theme
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


    property var model: sm.getCategories()
    property string selectedCategory: ""
    property int selectedIndex: -1
    property bool isLoading: false  // Add this property to control BusyIndicator visibility
    function refreshModel() {
        model = sm.getCategories()
        isLoading=true
    }
    onSelectedCategoryChanged: {
        rootAppWindow.currentCategory=selectedCategory
    }
    property int cellWidth: 120 * widthScale
    property int cellHeight: 40 * heightScale

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
                border.color:Theme.colorBackgroundView
                color:Theme.colorBackgroundView
                border.width: 2
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
                        root.selectedIndex = index
                        root.selectedCategory = modelData
                        console.log("Clicked category:", modelData)
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




    RowLayout {
        id:rowToolBtns
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10
        anchors.topMargin: 8
        VButton {
            text: "Add"
            onClicked: {
                categoryDialog.mode = "add"
                categoryDialog.open()
            }
            iconSource: "qrc:/vsonegx/qml/imgs/cil-plus.svg"
            fontPixelSize:9
            implicitHeightPadding:10
        }

        VButton {
            text: "Edit"
            enabled: root.selectedCategory !== ""
            onClicked: {
                categoryDialog.mode = "edit"
                categoryName.text = root.selectedCategory
                categoryDialog.open()
            }
            iconSource: "qrc:/vsonegx/qml/imgs/cil-pencil.svg"
            fontPixelSize:9
            implicitHeightPadding:10
        }

        VButton {
            text: "Delete"
            enabled: root.selectedCategory !== ""
            onClicked: deleteCategoryDialog.open()
            iconSource: "qrc:/vsonegx/qml/imgs/cil-trash.svg"
            fontPixelSize:9
            implicitHeightPadding:10
        }
    }

    Dialog {
        id: categoryDialog
        property string mode: "add"
        property string oldCategoryName: ""
        title: mode === "add" ? "Add Category" : "Edit Category"
        standardButtons: Dialog.Ok | Dialog.Cancel
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
            } else {
                oldCategoryName = root.selectedCategory
                categoryName.text = oldCategoryName
            }
        }

        onAccepted: {
            let result = sm.saveCategory(categoryName.text, mode === "add" ? 0 : 1, oldCategoryName)
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
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font.pointSize: 10* fontScale
                color:Theme.colorText
                text: "Are you sure you want to delete the category '" + root.selectedCategory + "'?"
            }
        }

        onAccepted: {
            sm.deleteCategory(root.selectedCategory)
            root.refreshModel()
            root.selectedCategory = ""
            root.selectedIndex = -1
        }
    }
    Connections {
        target: sm  // Assuming 'sm' is your C++ object
        function onCategoriesLoaded() {
            root.model = sm.getCategories()
            root.isLoading = false
        }
    }

}
