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
    }
}



