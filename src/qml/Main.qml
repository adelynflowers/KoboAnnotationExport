import QtQuick 
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import BookListLib
import KaeLib

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
                    onClicked: kaeLib.hello()
                }
            }
        }
    }
    ColumnLayout {
        anchors.fill: parent
        // Misc Row
        RowLayout {
            Layout.fillWidth: true 
            Layout.preferredHeight: 2
            TextField {
                Layout.fillWidth: true 
                Layout.fillHeight: true 
                placeholderText: qsTr("Type to begin searching")
                onTextEdited: function() {
                    console.log(text)
                }
            }
        }
        //Content Row
        RowLayout {
            Layout.fillWidth: true 
            Layout.preferredHeight: 8
            BookListView {
                id: bookList
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 50
            }
        }
    }
    KaeLib {id: kaeLib}
}
    // For dark mode/light mode coloring
    // SystemPalette {
    //     id: myPalette
    //     colorGroup: SystemPalette.Active
    // }
    // property color system_text_color: myPalette.text
