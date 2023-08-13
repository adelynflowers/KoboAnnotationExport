import QtQuick 
import QtQuick.Controls
import QtQuick.Layouts
import BookModelLib

Item {
    SystemPalette {
        id: palette
        colorGroup: SystemPalette.Active
    }
    width: ListView.view.width
    height: col.implicitHeight
    RowLayout {
        id: col
        width: parent.width
        z: 2
        ColumnLayout {
            Layout.preferredWidth: 9
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
            Layout.preferredWidth: 1
            Button {
                //TODO: Make global copy to clipboard function
                text: qsTr("Copy")
                z: 2
                Layout.alignment: Qt.AlignRight
            }
            Label {
                id: textItem
                Layout.fillWidth: true
                text: model.title
                font.italic: true 
                wrapMode: Text.WordWrap
                Layout.alignment: Qt.AlignRight
                horizontalAlignment: Text.AlignRight
                color: palette.placeholderText
            }
        }
    }
    Rectangle {
        anchors.fill: parent
        z: 1
        color: palette.base
    }
}



