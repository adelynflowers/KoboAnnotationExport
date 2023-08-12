import QtQuick 
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import BookModelLib

ApplicationWindow {
    visible: true
    width: 1280
    height: 720
    header: ToolBar {
        height: parent.height * 0.1
        RowLayout {
            spacing: 6
            anchors.fill: parent
            ColumnLayout {
                Layout.preferredWidth: 4
                Layout.fillHeight: true
                Label {
                    text: "Kae"
                    font.pixelSize: 24
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    verticalAlignment: Qt.AlignVCenter
                }
            }
            RowLayout {
                Layout.preferredWidth: 6
                Layout.fillHeight: true
                ToolButton {
                    text: qsTr("Extract")
                    font.pixelSize: 24
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
                ToolButton {
                    text: qsTr("Sync")
                    font.pixelSize: 24
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
                ToolButton {
                    text: qsTr("Settings")
                    font.pixelSize: 24
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }
    }
    RowLayout {
        //Content Row
        anchors.fill: parent
        BookListView {
            id: bookList
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 50
        }
    }
}
    // For dark mode/light mode coloring
    // SystemPalette {
    //     id: myPalette
    //     colorGroup: SystemPalette.Active
    // }
    // property color system_text_color: myPalette.text
