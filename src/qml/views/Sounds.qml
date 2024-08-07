import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../layouts/layers"
import "../layouts/sounds"
import "../controls"
import com.sonegx.midiclient

VSplitView {
    property int baseWidth: rootAppWindow.winBaseWidth
    property int baseHeight: rootAppWindow.winBaseHeight
    property real widthScale: rootAppWindow.width / baseWidth
    property real heightScale: rootAppWindow.height / baseHeight
    property bool quickSetSplitToggle: quickSetSplit.toggled
    property real fontScale: Math.max(widthScale, heightScale)
    id:soundsView
    orientation: Qt.Vertical
    toggle: false

    VSoundsCategories{
        SplitView.fillWidth :true
        z:3
        SplitView.minimumHeight: 140 *heightScale
        SplitView.preferredHeight: 140 *heightScale
        SplitView.maximumHeight: 140 * heightScale
    }
    VSoundsContainer {
          SplitView.fillWidth :true
          SplitView.fillHeight: true

    }

}


