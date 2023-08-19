import QtQuick 
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import BookListLib

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
                id: annotationSearch
                Layout.fillWidth: true 
                Layout.fillHeight: true 
                placeholderText: qsTr("Type to begin searching")
                onTextEdited: function() {
                    bookList.searchAnnotations(annotationSearch.text)
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
                Layout.leftMargin: 5
                Layout.rightMargin: 5
                Connections {
                    target: kaeLib 
                    function onAppReady(filename) {
                        bookList.openApplicationDB(filename);
                    }
                }
            }
        }
    }

    MessageDialog {
        id: detectionDialog
        text: qsTr("Device detected")
        informativeText: qsTr("A Kobo device has been detected, extract annotations?")
        property string detectedPath;
        buttons: MessageDialog.Yes | MessageDialog.No
        onAccepted: {
            let detectedPath = detectionDialog.detectedPath
            let success = bookList.openKoboDB(detectedPath);
            if (success) {
                    console.log("Successfully opened DB at ", detectedPath);
                    kaeLib.currentDevice = detectedPath;
            } else {
                console.log("Failed to open DB at ", detectedPath, ". blacklisting");
                //TODO: Better way to handle failure
                kaeLib.blacklistDevice(detectedPath);
            }
        }
        onRejected: {
            // No is an explicit blacklist
            console.log("Blacklisting device ", detectedPath);
            kaeLib.blacklistDevice(detectedPath);
        }
        Connections {
            target: kaeLib 
            function onDeviceDetected(dbPath) {
            if (!detectionDialog.visible) {
                detectionDialog.detectedPath = dbPath;
                detectionDialog.open();
            }
        }
        }
        
    }
}
    
