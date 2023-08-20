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
    height: expanded ? col.implicitHeight + 10 : 0
    visible: expanded ? true : false
    Behavior on height {
        NumberAnimation{duration: 200}
    }
    RowLayout {
        id: col
        width: parent.width
        z: 2
        ColumnLayout {
            Layout.fillHeight: true 
            Layout.preferredWidth: 1
            Button {
                text: "\uF0C5"
                font.family: "fontello"
                flat: true
                Layout.fillHeight: false
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.topMargin: 10
                z: 2
                onClicked: kaeLib.copyToClipboard(model.text)
            }
        }
        ColumnLayout {
            Layout.preferredWidth: 8 
            Layout.fillHeight: true
            Label {
                id: textItem2
                Layout.fillWidth: true
                Layout.topMargin: 10
                Layout.leftMargin: 20
                Layout.rightMargin: 50
                horizontalAlignment: Text.AlignLeft
                text: model.text
                wrapMode: Text.WordWrap
            }
        }
        ColumnLayout {
            Layout.preferredWidth: 1
            Layout.fillHeight: true 
            Label {
                Layout.topMargin: 10
                Layout.rightMargin: 5
                Layout.fillWidth: true 
                Layout.fillHeight: true 
                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignRight
                text: model.date
                font.italic: true 
                wrapMode: Text.WordWrap
                color: palette.placeholderText
            }
        }
    }
    Rectangle {
        anchors.fill: parent
        anchors.rightMargin: -1
        anchors.topMargin: 0
        anchors.leftMargin: -1
        z: 1
        opacity: 0.3
        color: palette.window
        border.width: 1
        radius: 2
        border.color: palette.alternateBase
    }
}



