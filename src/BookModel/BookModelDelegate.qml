import QtQuick 
import QtQuick.Controls
import QtQuick.Layouts
import BookModelLib

Item {
    width: ListView.view.width
    height: col.implicitHeight
    z: 2
    Button {
        text: qsTr("Copy")
        onClicked: function() {
            parent.ListView.view.model.copyToClipboard(model.text);
        }
        anchors.top: parent.top 
        anchors.right: parent.right
    }
    ColumnLayout {
        id: col
        width: parent.width
        Label {
            id: textItem
            Layout.fillWidth: true
            text: model.title
            font.italic: true 
            font.bold: true
            wrapMode: Text.WordWrap
        }
        Label {
            id: textItem2
            Layout.fillWidth: true
            Layout.leftMargin: 10
            text: model.text
            wrapMode: Text.WordWrap
        }
    }
}



