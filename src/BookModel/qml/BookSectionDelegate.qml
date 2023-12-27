import QtQuick
import QtQuick.Controls.Basic

Label {
    signal clicked

    font.family: "fontello"
    font.pixelSize: 24
    height: ListView.view.sectionsEnabled ? implicitHeight + 20 : 0
    horizontalAlignment: Text.AlignLeft
    color: "white"
    text: ListView.view.sectionsEnabled ? (ListView.view.isExpanded(section) ? "\uE800 " : "\uE801 ") + section : ""
    verticalAlignment: Text.AlignBottom

    Behavior on height {
        NumberAnimation {
            duration: 200
        }
    }

    //TODO: figure out bottom margin
    onClicked: ListView.view.toggleSection(section)

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            parent.clicked();
        }
    }
}
