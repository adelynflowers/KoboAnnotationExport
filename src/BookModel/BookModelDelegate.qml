import QtQuick 
import QtQuick.Controls
import QtQuick.Layouts
import BookModelLib

Item {
    SystemPalette {
        id: palette
        colorGroup: SystemPalette.Active
    }
    property bool expanded: ListView.view.isExpanded(title)
    width: ListView.view.width
    height: expanded ? col.implicitHeight : 0
    visible: expanded ? true : false
    Behavior on height {
        NumberAnimation{duration: 200}
    }
    RowLayout {
        id: col
        width: parent.width
        z: 2
        ColumnLayout {
            Layout.preferredWidth: 8 
            Layout.fillHeight: true
            Label {
                id: textItem2
                Layout.fillWidth: true
                Layout.leftMargin: 10
                Layout.rightMargin: 50
                text: model.text
                wrapMode: Text.WordWrap
            }
        }
        ColumnLayout {
            Layout.fillHeight: true 
            Layout.preferredWidth: 2
            Button {
                text: "\uF0C5"
                font.family: "fontello"
                Layout.alignment: Qt.AlignRight
                flat: true
                z: 2
                onClicked: kaeLib.copyToClipboard(model.text)
            }
            Label {
                id: textItem
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                Layout.rightMargin: 2
                text: model.title
                font.italic: true 
                wrapMode: Text.WordWrap
                color: palette.placeholderText
            }
        }
    }
    Rectangle {
        anchors.fill: parent
        z: 1
        color: palette.base
        border.width: 1
        border.color: palette.alternateBase
    }
}



