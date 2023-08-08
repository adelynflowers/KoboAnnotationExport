import QtQuick 
import QtQuick.Controls 
import QtQuick.Layouts
import QtQuick.Dialogs
import BookModelLib

Page {
    title: qsTr("First page")
    ColumnLayout {
        spacing: 0
        anchors.fill: parent
        RowLayout {
            //Header row
            Layout.preferredHeight: 2
            Layout.fillWidth: true
            //Spacer
            Rectangle {
                color: "red"
                Layout.fillWidth: true 
                Layout.fillHeight: true
            } 
        }
        RowLayout {
            //Content Row
            Layout.preferredHeight: 6
            Layout.fillWidth: true
            ColumnLayout {
                Layout.preferredWidth: 2
                Layout.fillHeight: true
                //Spacer
                ToolButton {
                    id: fileButton
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    text: "Open Database" 
                    onClicked: fileDialog.open()
                    FileDialog {
                        id: fileDialog
                        onAccepted: {
                            console.log(selectedFile) 
                            bookList.fileName = selectedFile
                        }
                    }
                }
                ToolButton {
                    id: extractBtn 
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    text: "Extract" 
                    onClicked: bookList.extract()
                }
            }
            ColumnLayout {
                Layout.preferredWidth: 6
                Layout.fillHeight: true
                BookListView {
                    id: bookList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
            ColumnLayout {
                Layout.preferredWidth: 2
                Layout.fillHeight: true
                ToolButton {
                    id: toolButton 
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    text: "Press to go to second page" 
                    onClicked: stackView.push("Second.qml")
                }
            }
        }
        RowLayout {
            // Footer row
            Layout.preferredHeight: 2
            Layout.fillWidth: true
            //Spacer
            Rectangle {
                color: "green"
                Layout.fillWidth: true 
                Layout.fillHeight: true
            }
        }
    }
}